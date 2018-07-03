//
//  TimeZone+Extensions.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

extension TimeZone {

    static var utc: TimeZone {
         return TimeZone(secondsFromGMT: 0)!
    }
}
