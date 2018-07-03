//
//  DataStoreProvider.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import RealmSwift

protocol DataStoreProvidable {

    func getStore(for userId: Int) throws -> Realm
}

class DefaultDataStoreProvider: DataStoreProvidable {

    func getStore(for userId: Int = 0) throws -> Realm {
        return try Realm(fileURL: provideDatabaseUrl(for: userId))
    }

    private func provideDatabaseUrl(for userId: Int) throws -> URL {
        let fileName = String(format:"user_%li.realm", userId)
        guard let url = URL.createUrl(with: fileName, in: .documentDirectory) else {
            throw DataStoreError.invalidDatabaseUrlError
        }
        return url
    }
}
