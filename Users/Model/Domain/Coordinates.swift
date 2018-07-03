//
//  Coordinates.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift
import MapKit

@objcMembers
class Coordinates: Object, JSONDecodable {

    internal dynamic var latitude: CLLocationDegrees = 0.0
    internal dynamic var longitude: CLLocationDegrees = 0.0

// MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard
            let latitude: CLLocationDegrees = Keys.latitude <~~ json,
            let longitude: CLLocationDegrees = Keys.longitude <~~ json
            else { return nil  }
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }

    private struct Keys {
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
}

// MARK: - Utils

extension Coordinates {

    internal var toLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
