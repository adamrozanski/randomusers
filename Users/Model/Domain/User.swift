//
//  User.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class User: Object, JSONDecodable {

    internal dynamic var objectId: String = ObjectIdProvider.provideUniqueId()
    internal dynamic var gender: String = ""
    internal dynamic var name: UserName?
    internal dynamic var location: Location?
    internal dynamic var email: String = ""
    internal dynamic var login: LoginData?
    internal dynamic var birthDateInfo: DateInfo?
    internal dynamic var registrationDateInfo: DateInfo?
    internal dynamic var phone: String = ""
    internal dynamic var cell: String = ""
    internal dynamic var identifier: Identifier?
    internal dynamic var imageUrls: ImageUrls?
    internal dynamic var nationality: String = ""

    override static func primaryKey() -> String? {
        return "objectId"
    }

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard
            let gender: String = Keys.gender <~~ json,
            let name: UserName = Keys.name <~~ json,
            let location: Location = Keys.location <~~ json,
            let email: String = Keys.email <~~ json,
            let login: LoginData = Keys.login <~~ json,
            let birthDate: DateInfo = Keys.birthDate <~~ json,
            let registrationDate: DateInfo = Keys.registrationDate <~~ json,
            let phone: String = Keys.phone <~~ json,
            let cell: String = Keys.cell <~~ json,
            let id: Identifier = Keys.identifier <~~ json,
            let imageUrls: ImageUrls = Keys.imageUrls <~~ json,
            let nationality: String = Keys.nationality <~~ json
            else { return nil  }
        self.init()
        self.gender = gender
        self.name = name
        self.location = location
        self.email = email
        self.login = login
        self.birthDateInfo = birthDate
        self.registrationDateInfo = registrationDate
        self.phone = phone
        self.cell = cell
        self.identifier = id
        self.imageUrls = imageUrls
        self.nationality = nationality
    }

    private struct Keys {
        static let gender = "gender"
        static let name = "name"
        static let location = "location"
        static let email = "email"
        static let login = "login"
        static let birthDate = "dob"
        static let registrationDate = "registered"
        static let phone = "phone"
        static let cell = "cell"
        static let identifier = "id"
        static let imageUrls = "picture"
        static let nationality = "nat"
    }
}

// MARK: - Utils

extension User: SearchFieldsProviding {

    var searchFields: [String] {
        let searchFiels = [
            email,
            phone,
            cell
        ]
        let locationSearchFields = location?.searchFields ?? []
        let nameSearchFields = name?.searchFields ?? []
        let idSearchFields = identifier?.searchFields ?? []
        return searchFiels + nameSearchFields + locationSearchFields + idSearchFields
    }
}

extension User {

    internal func getSex() -> Sex? {
        return Sex(rawValue: self.gender)
    }
}
