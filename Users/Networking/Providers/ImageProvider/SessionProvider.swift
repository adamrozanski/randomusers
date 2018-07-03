//
//  SessionProvider.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

class SessionProvider {

    internal static func provideDownloadsSession(delegate: URLSessionTaskDelegate, queue: OperationQueue) -> URLSession {
        let configuration = SessionProvider.deafultSesionConfiguration()
        configuration.httpMaximumConnectionsPerHost = 4
        let session = URLSession(configuration:configuration, delegate: delegate, delegateQueue: queue)
        return session
    }

    static func deafultSesionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.timeoutIntervalForRequest = 180
        configuration.allowsCellularAccess = true
        configuration.httpShouldSetCookies = false
        return configuration
    }

}
