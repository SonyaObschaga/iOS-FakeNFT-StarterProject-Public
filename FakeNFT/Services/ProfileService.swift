//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Илья on 01.12.2025.
//

import Foundation

typealias ProfileCompletion = (Result<ProfileResponse, Error>) -> Void

protocol ProfileService {
    func loadProfile(profileId: String, completion: @escaping ProfileCompletion)
    func updateProfile(profileId: String, likes: [String], completion: @escaping ProfileCompletion)}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(profileId: String, completion: @escaping ProfileCompletion) {
        let request = ProfileRequest(profileId: profileId)
        networkClient.send(request: request, type: ProfileResponse.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(profileId: String, likes: [String], completion: @escaping ProfileCompletion) {
            let request = UpdateProfileRequest(profileId: profileId, likes: likes)
            networkClient.send(request: request, type: ProfileResponse.self) { result in
                switch result {
                case .success(let profile):
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}

//todo

//
//  ProfileService.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 02.12.2025.
//
//typealias ProfileOperationCompletion = (Result<ProfileDto, Error>) -> Void
//
//protocol ProfileService {
//    var inMemoryStorageProfile: ProfileDto? {get}
//    func loadProfile(id: Int, completion: @escaping ProfileOperationCompletion)
//    func saveProfile(id: Int, profile: ProfileDto, completion: @escaping ProfileOperationCompletion)
//    
//    func updateProfile(profileId: String, likes: [String], completion: @escaping ProfileOperationCompletion)
//
//}
//
//final class ProfileServiceImpl: ProfileService
//{
//    private let networkClient: NetworkClient
//    private let storage: ProfileStorage
//    
//    init(networkClient: NetworkClient, storage: ProfileStorage) {
//        self.storage = storage
//        self.networkClient = networkClient
//    }
//    
//    var inMemoryStorageProfile: ProfileDto? {
//        let id = FakeNFTModelServiceAgent.DEFAULT_USER_INDEX
//        guard let profile = storage.getProfile(with: "\(id)")  else {
//            return nil
//        }
//        return profile
//    }
//
//    func loadProfile(id: Int, completion: @escaping ProfileOperationCompletion) {
//        if let profile = storage.getProfile(with: "\(id)") {
//            print("Profile retrieved from storage, Id = \(profile.id)")
//            completion(.success(profile))
//            return
//        }
//        
//        let request = ProfileRequest(profileId: "\(id)")
//
//        networkClient.send(request: request, type: ProfileDto.self) { [weak storage] result in
//            switch result {
//            case .success(let profile):
//                storage?.saveProfile(profile)
//                completion(.success(profile))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func saveProfile(id: Int, profile: ProfileDto, completion: @escaping ProfileOperationCompletion) {
//        let request = ProfilePutRequest(index: id, profile: profile )
//        
//        networkClient.send(request: request, type: ProfileDto.self) { [weak storage] result in
//            switch result {
//            case .success(let profile):
//                storage?.saveProfile(profile)
//                completion(.success(profile))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//
//    }
//    
//    func updateProfile(profileId: String, likes: [String], completion: @escaping ProfileOperationCompletion) {
//            let request = UpdateProfileRequest(profileId: profileId, likes: likes)
//            networkClient.send(request: request, type: ProfileDto.self) { [weak storage] result in
//                 switch result {
//                case .success(let profile):
//                    storage?.saveProfile(profile)
//                    completion(.success(profile))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//
//}
