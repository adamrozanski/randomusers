//
//  Constants.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

struct Constants {

    struct HTTPHeaderKey {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }

    struct ContentType {
        static let JSON = "application/json;charset=UTF-8"
        static let URLEncoded = "application/x-www-form-urlencoded"
    }

    struct HTTPStatusCode {

        static let success: Int = 200
        static let unauthenticated: Int = 401
    }
}
