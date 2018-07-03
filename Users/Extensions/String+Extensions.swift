//
//  String+Extensions.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

extension String {

    func toDate(format: Date.Format = .timeStamp) -> Date? {
        return Date.dateFormatter(format: format).date(from: self)
    }

    func toAttributedStringWithFont(_ font: UIFont, color: UIColor, backgroundColor: UIColor? = nil) -> NSAttributedString {
        var attributes: [NSAttributedStringKey: NSObject] = [
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor : color
        ]
        if let backgroundColor = backgroundColor {
            attributes[NSAttributedStringKey.backgroundColor] = backgroundColor
        }
        return NSAttributedString(string: self, attributes: attributes)
    }
}
