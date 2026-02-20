//
//  FakeNFTModelServicesNotifications.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 10.12.2025.
//

import Foundation

// MARK: - Notifications
final class FakeNFTModelServicesNotifications {
    static let profileLoadedNotification = Notification.Name(rawValue: "ProfileLoaded")
    static let profileSavedNotification = Notification.Name(rawValue: "ProfileSaved")
    static let profileNTFsLoadedNotification = Notification.Name(rawValue: "ProfileNTFsLoaded")
    static let profileLikedNTFsLoadedNotification = Notification.Name(rawValue: "ProfileLikedNTFsLoaded")
    static let likedNFTSavedNotification = Notification.Name(rawValue: "LikedNFTSaved")
}
