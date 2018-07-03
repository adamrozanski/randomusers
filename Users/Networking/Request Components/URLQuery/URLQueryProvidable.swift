//
//  URLQueryProvidable
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol URLQueryProvidable {

    func apiConfiguration() -> APIConfigurable
    func endpointPath() -> String?
    func queryItems() -> [URLQueryItem]?
    func urlComponents() -> URLComponents
    var absoluteURL: URL { get }
}

extension URLQueryProvidable {

    func apiConfiguration() -> APIConfigurable {
        return APIConfigurationProvider.getConfiguration()
    }

    func endpointPath() -> String? {
        return nil
    }

    func queryItems() -> [URLQueryItem]? {
        return nil
    }

    func urlComponents() -> URLComponents {
        let path = endpointPath() ?? String()
        let baseUrl = URL(string: self.apiConfiguration().baseUrl)!
        let url = URL(string: path, relativeTo: baseUrl)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems()
        return components
    }

    var absoluteURL: URL {
        return urlComponents().url!
    }
}
