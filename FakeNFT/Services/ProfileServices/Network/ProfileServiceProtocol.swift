//
//  ProfileServiceProtocol.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//

protocol ProfileService {
    var inMemoryStorageProfile: ProfileDto? {get}
    func loadProfile(id: Int, completion: @escaping ProfileOperationCompletion)
    func saveProfile(id: Int, profile: ProfileDto, completion: @escaping ProfileOperationCompletion)
}

