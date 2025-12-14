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
