//
//  PageInfo.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Gloss
import Foundation
import RealmSwift

struct Page {

    internal static var defaultResultsCount: UInt = 20

    internal let index: UInt
    internal let resultsCount: UInt
    internal var version: String
    internal let seedId: String?
}

// MARK: - Glossy

extension Page: Glossy {

    internal init?(json: JSON) {
        guard
            let resultsCount: UInt = Keys.resultsCount <~~ json,
            let index: UInt = Keys.index <~~ json,
            let version: String = Keys.version <~~ json
            else { return nil  }
        let seedId: String? = Keys.seedId <~~ json
        self.init(index: index, resultsCount: resultsCount, seedId: seedId)
        self.version = version
    }

    internal func toJSON() -> JSON? {
        return [
            Keys.index : self.index,
            Keys.resultsCount : self.resultsCount
        ]
    }

    private struct Keys {
        static let seedId = "seed"
        static let resultsCount = "results"
        static let index = "page"
        static let version = "version"
    }
}

// MARK: - Utils

extension Page {

    internal static func initialPage() -> Page {
        return Page(index: 1, resultsCount: Page.defaultResultsCount, seedId: nil)
    }

    private init(index: UInt, resultsCount: UInt, seedId: String?, apiVersion: String = APIConfigurationProvider.getConfiguration().apiVersion) {
        self.index = index
        self.resultsCount = resultsCount
        self.version = apiVersion
        self.seedId = seedId
    }

    internal func next() -> Page {
        return Page(index: index + 1, resultsCount: resultsCount, seedId: seedId)
    }

    internal func previous() -> Page {
        let index = self.index > 0 ? self.index - 1 : self.index
        return Page(index: index, resultsCount: resultsCount, seedId: seedId)
    }
}
