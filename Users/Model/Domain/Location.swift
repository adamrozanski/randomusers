//
//  Location.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class Location: Object, JSONDecodable {

    internal dynamic var street: String = ""
    internal dynamic var city: String = ""
    internal dynamic var state: String = ""
    internal dynamic var postcode: String = ""

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        self.init()
        guard
            let street: String = Keys.street <~~ json,
            let city: String = Keys.city <~~ json,
            let state: String = Keys.state <~~ json,
            let postcode: String = convertToString(value: Keys.postcode <~~ json)
            else { return nil  }
        self.street = street
        self.city = city
        self.state = state
        self.postcode = postcode
    }

    private struct Keys {
        static let street = "street"
        static let city = "city"
        static let state = "state"
        static let postcode = "postcode"
    }
}

// MARK: - Utils

extension Location {

    private func convertToString(value: Any?) -> String? {
        if let value = value {
            return "\(value)"
        }
        return nil
    }

    internal var toAddressString: String? {
        return String(format:"%@, %@", city, street)
    }
}

extension Location: SearchFieldsProviding {

    var searchFields: [String] {
        return [
            street,
            city,
            state,
            postcode
        ]
    }

}
