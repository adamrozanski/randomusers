//
//  ImageUrls.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

@objcMembers
class ImageUrls: Object, JSONDecodable {

    internal dynamic var large: String = ""
    internal dynamic var medium: String = ""
    internal dynamic var thumbnail: String = ""

    // MARK: - JSONDecodable

    internal required convenience init?(json: JSON) {
        guard
            let large: String = Keys.large <~~ json,
            let medium: String = Keys.medium <~~ json,
            let thumbnail: String = Keys.thumbnail <~~ json
            else { return nil }
        self.init()
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }

    private struct Keys {
        static let large = "large"
        static let medium = "medium"
        static let thumbnail = "thumbnail"
    }
}

// MARK: - Utils

extension ImageUrls {

    internal enum ImageType {
        case large, medium, thumbnail
    }

    internal func getUrl(for type: ImageType) -> URL? {
        var urlString: String!
        switch type {
        case .large: urlString = self.large
        case .medium: urlString = self.medium
        case .thumbnail: urlString = self.thumbnail
        }
        return URL(string: urlString)
    }
}
