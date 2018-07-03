//
//  LoginData.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class LoginData: Object, JSONDecodable {

    internal dynamic var uuid: String = ""
    internal dynamic var userName: String = ""
    internal dynamic var password: String = ""
    internal dynamic var salt: String = ""
    internal dynamic var md5: String = ""
    internal dynamic var sha1: String = ""
    internal dynamic var sha256: String = ""

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard
            let uuid: String = Keys.uuid <~~ json,
            let userName: String = Keys.userName <~~ json,
            let password: String = Keys.password <~~ json,
            let salt: String = Keys.salt <~~ json,
            let md5: String = Keys.md5 <~~ json,
            let sha1: String = Keys.sha1 <~~ json,
            let sha256: String = Keys.sha256 <~~ json
            else { return nil }
        self.init()
        self.uuid = uuid
        self.userName = userName
        self.password = password
        self.salt = salt
        self.md5 = md5
        self.sha1 = sha1
        self.sha256 = sha256
    }

    private struct Keys {
        static let uuid = "uuid"
        static let userName = "username"
        static let password = "password"
        static let salt = "salt"
        static let md5 = "md5"
        static let sha1 = "sha1"
        static let sha256 = "sha256"
    }
}
