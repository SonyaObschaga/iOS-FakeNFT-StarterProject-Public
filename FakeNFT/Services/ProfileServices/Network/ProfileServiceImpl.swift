//
//  ProfileService.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 02.12.2025.
//




/*
 protocol ProfileService {
     func loadProfile(id: Int, completion: @escaping ProfileOperationCompletion)
     func saveProfile(id: Int, profile: ProfileDto, completion: @escaping ProfileOperationCompletion)
 }


 */

final class ProfileServiceImpl: ProfileService
                                 {
    private let networkClient: NetworkClient
    private let storage: ProfileStorage
    
    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    var inMemoryStorageProfile: ProfileDto? {
        let id = FakeNFTService.DEFAULT_USER_INDEX
        guard let profile = storage.getProfile(with: "\(id)")  else {
            return nil
        }
        return profile
    }

    func loadProfile(id: Int, completion: @escaping ProfileOperationCompletion) {
        if let profile = storage.getProfile(with: "\(id)") {
            print("Profile retrieved from storage, Id = \(profile.id)")
            completion(.success(profile))
            return
        }
        
        let request = ProfileRequest(id: id)
        
        networkClient.send(request: request, type: ProfileDto.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveProfile(id: Int, profile: ProfileDto, completion: @escaping ProfileOperationCompletion) {
        let request = ProfilePutRequest(index: id, profile: profile )
        
        networkClient.send(request: request, type: ProfileDto.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    

}
