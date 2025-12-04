//
//  ProfileStorage.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 02.12.2025.
//

import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(_ profile: ProfileDto)
    func getProfile(with id: String) -> ProfileDto?
}

// Пример простого класса, который сохраняет данные из сети
final class ProfileStorageImpl: ProfileStorage {
    private var storage: [String: ProfileDto] = [:]

    private let syncQueue = DispatchQueue(label: "sync-profile-queue")

    func saveProfile(_ profile: ProfileDto) {
        syncQueue.async { [weak self] in
            self?.storage[profile.id] = profile
        }
    }

    func getProfile(with id: String) -> ProfileDto? {
        syncQueue.sync {
            storage[id]
        }
    }
}
