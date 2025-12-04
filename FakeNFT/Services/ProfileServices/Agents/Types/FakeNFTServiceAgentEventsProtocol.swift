//
//  FakeNFTServiceAgentEventsProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//

import Foundation

protocol FakeNFTServiceAgentNotificationsProtocol {
    var profileLoadedNotification: Notification.Name { get }
    var profileSavedNotification: Notification.Name { get }
    var profileNTFsLoadedNotification: Notification.Name { get }
}

// Example implementation
struct AppNotificationNames: FakeNFTServiceAgentNotificationsProtocol {
    let profileLoadedNotification = Notification.Name(rawValue: "ProfileLoaded")
    let profileSavedNotification = Notification.Name(rawValue: "ProfileSaved")
    let profileNTFsLoadedNotification = Notification.Name(rawValue: "ProfileNTFsLoaded")
}

//not used for implementation
protocol FakeNFTServiceAgentEventsProtocol {
    var profileLoadingStarted: ProfileLoadingStarted? {get set}
    var profileLoadingCompleted: ProfileLoadingCompleted? {get set}
}

