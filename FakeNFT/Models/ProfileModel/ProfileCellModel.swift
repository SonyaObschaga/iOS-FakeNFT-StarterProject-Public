//
//  ProfileCellModel.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import Foundation

struct ProfileCellModel {
    let name: String
    var count: Int?
    let action: () -> Void
}
