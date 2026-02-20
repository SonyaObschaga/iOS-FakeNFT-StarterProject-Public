//
//  RuntimeError.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

struct NotImplementedException: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
