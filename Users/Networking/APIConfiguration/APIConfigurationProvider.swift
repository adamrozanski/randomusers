//
//  APIConfigurationProvider.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol APIConfigurationProviding {

    static func getConfiguration() -> APIConfigurable
}

class APIConfigurationProvider: APIConfigurationProviding {

    static func getConfiguration() -> APIConfigurable {
        return ProductionAPIConfiguration()
    }
}
