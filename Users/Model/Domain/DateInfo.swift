//
//  DateInfo
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class DateInfo: Object, JSONDecodable {

    internal dynamic var date: Date?
    internal dynamic var age: Int8 = 0

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard
            let dateString: String = Keys.date <~~ json,
            let date: Date = dateString.toDate(format: .timeStamp),
            let age: Int8 = Keys.age <~~ json
            else { return nil }
        self.init()
        self.date = date
        self.age = age
    }

    private struct Keys {
        static let date = "date"
        static let age = "age"
    }
}
