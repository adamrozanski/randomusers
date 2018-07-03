//
//  Identifier.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class Identifier: Object, JSONDecodable {

    internal dynamic var name: String = ""
    internal dynamic var value: String?

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard let name: String = Keys.name <~~ json else {
            return nil
        }
        self.init()
        self.name = name
        self.value =  Keys.value <~~ json
    }

    private struct Keys {
        static let name = "name"
        static let value = "value"
    }
}

// MARK: - Utils

extension Identifier: SearchFieldsProviding {

    var searchFields: [String] {
        return [
            name,
            value ?? ""
        ]
    }
}

