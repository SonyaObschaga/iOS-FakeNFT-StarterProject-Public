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

struct AppNotificationNames: FakeNFTServiceAgentNotificationsProtocol {
    let profileLoadedNotification = Notification.Name(rawValue: "ProfileLoaded")
    let profileSavedNotification = Notification.Name(rawValue: "ProfileSaved")
    let profileNTFsLoadedNotification = Notification.Name(rawValue: "ProfileNTFsLoaded")
}
