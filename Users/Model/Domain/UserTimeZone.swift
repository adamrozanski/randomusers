//
//  UserTimeZone.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class UserTimeZone: Object, JSONDecodable {

    internal dynamic var offset: String = ""
    internal dynamic var zoneDescription: String = ""

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard
            let offset: String = Keys.offset <~~ json,
            let description: String = Keys.description <~~ json
            else { return nil  }
        self.init()
        self.offset = offset
        self.zoneDescription = description
    }

    private struct Keys {
        static let offset = "offset"
        static let description = "description"
    }
}

// MARK: - Utils

extension UserTimeZone {

    internal var toTimeZone: TimeZone? {
        if let offsetInterval = TimeInterval(signedHhmm: self.offset) {
            return TimeZone(secondsFromGMT: Int(offsetInterval))
        }
        return nil
    }
}
