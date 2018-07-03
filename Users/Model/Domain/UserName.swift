//
//  UserName.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class UserName: Object, JSONDecodable {

    internal dynamic var title: String = ""
    internal dynamic var firstName: String = ""
    internal dynamic var lastName: String = ""

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard
            let title: String = Keys.title <~~ json,
            let firstName: String = Keys.firstName <~~ json,
            let lastName: String = Keys.lastName <~~ json
            else { return nil  }
        self.init()
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
    }

    private struct Keys {
        static let title = "title"
        static let firstName = "first"
        static let lastName = "last"
    }
}

// MARK: - Utils

extension UserName {

    internal var toFullNameString: String {
        return String(format: "%@ %@", firstName, lastName)
    }
}

extension UserName: SearchFieldsProviding {

    var searchFields: [String] {
        return [
            toFullNameString
        ]
    }
}

