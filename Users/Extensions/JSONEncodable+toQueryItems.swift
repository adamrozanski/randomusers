//
//  JSON+toQueryItems.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Gloss

extension JSONEncodable {

    internal func toQueryItems() -> [URLQueryItem]? {
        if let json = self.toJSON() {
            return json.keys.map { URLQueryItem(name: $0, value: "\(json[$0]!)") }
        }
        return nil
    }
}
