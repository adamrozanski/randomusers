//
//  ErrorResponse.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Gloss

struct ErrorResponse {

    let message: String
}

// MARK: - JSONDecodable

extension ErrorResponse: JSONDecodable {

    init?(json: JSON) {
        guard
            let message: String = Keys.message <~~ json
            else { return nil }

        self.message = message
    }

    struct Keys {
        static let message = "error"
    }
}
