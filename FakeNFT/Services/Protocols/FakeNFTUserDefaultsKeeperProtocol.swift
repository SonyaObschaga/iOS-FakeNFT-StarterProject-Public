//
//  FakeNFTUserDefaultsKeeperProtocol.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 27.11.2025.
//
protocol FakeNFTUserDefaultsKeeperProtocol {
    func loadUserDefaults() -> ProfileModel
    func saveUserDefaults(_ profile: ProfileModel)
    func resetUserDefaults() -> ProfileModel
}
