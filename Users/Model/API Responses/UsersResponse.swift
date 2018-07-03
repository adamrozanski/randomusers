//
//  UsersResponse.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Gloss

struct UsersResponse {

    let users: [User]
    let page: Page
}

// MARK: - JSONDecodable

extension UsersResponse: JSONDecodable {

    init?(json: JSON) {
        guard
            let users: [User] = Keys.users <~~ json,
            let page: Page = Keys.page <~~ json
            else { return nil }

        self.users = users
        self.page = page
    }

    struct Keys {
        static let users = "results"
        static let page = "info"
    }
}
