//
//  Date+Extensions.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

extension Date {

    enum Format: String {
        case timeStamp = "yyyy-MM-dd'T'HH:mm:ssZ"
        case readableDate = "d MMMM yyyy"
    }

    static func dateFormatter(format: Format = .timeStamp, timeZone: TimeZone = TimeZone.utc, locale: Locale = Locale.current) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter
    }

    func toString(format: Format = .timeStamp, timeZone: TimeZone = TimeZone.utc, locale: Locale = Locale.current) -> String {
        let formatter = Date.dateFormatter(format: format, timeZone: timeZone, locale: locale)
        return formatter.string(from: self)
    }
}
