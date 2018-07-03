//
//  ObjectIdProvider.swift
//  Users
//
//  Created by Adam on 02/07/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

class ObjectIdProvider {

    static func provideUniqueId() -> String {
        return UUID().uuidString
    }

}
