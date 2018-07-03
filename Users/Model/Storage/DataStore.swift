//
//  DataStore.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import RealmSwift

enum DataStoreError: String, Error {
    case invalidDatabaseUrlError = "Invalid database file path"
}

protocol DataStorable: class {

    func fetchUsers() -> Results<User>?
    func objects<Element: Object>(_ type: Element.Type) -> Results<Element>?
    func object<Element: Object>(_ type: Element.Type, withPrimaryKey key: String) -> Element?

    func insert(_ object: Object, notifyUI: Bool)
    func insert(_ objects: [Object], notifyUI: Bool)

    func delete(_ object: Object, notifyUI: Bool)
    func delete(_ objects: [Object], notifyUI: Bool)

    func registerNotification(_ token: NotificationToken?)
    func removeNotification(_ token: NotificationToken?)
    func setErrorListener(_ errorListener: UIViewController)
}

class DataStore: DataStorable {

    internal static var notificationTokens: [NotificationToken] = []
    private let storeProvider: DataStoreProvidable
    fileprivate weak var errorListener: ErrorListener?

    internal init(storeProvider: DataStoreProvidable) {
        self.storeProvider = storeProvider
    }

    private lazy var store: Realm? = {
        do {
            return try storeProvider.getStore(for: 0)
        } catch let error {
            self.errorListener?.dbRequestDidFail(with: error.localizedDescription, sender: self)
        }
        return nil
    }()

    func setErrorListener(_ errorListener: UIViewController) {
        self.errorListener = errorListener
    }

    // MARK: - Notifications

    func registerNotification(_ token: NotificationToken?) {
        if let token = token {
            DataStore.notificationTokens.append(token)
        }
    }

    func removeNotification(_ token: NotificationToken?) {
        if let token = token, let idx = DataStore.notificationTokens.index(of: token) {
            DataStore.notificationTokens.remove(at: idx)
        }
    }

    // MARK: - Fetches

    func fetchUsers() -> Results<User>? {
        return store?.objects(User.self)
    }

    func objects<Element: Object>(_ type: Element.Type) -> Results<Element>? {
        return store?.objects(type)
    }

    func object<Element: Object>(_ type: Element.Type, withPrimaryKey key: String) -> Element? {
        return store?.object(ofType: type, forPrimaryKey: key)!
    }

    // MARK: - Deletions

    func delete(_ object: Object, notifyUI: Bool) {
        delete([object], notifyUI: notifyUI)
    }

    func delete(_ objects: [Object], notifyUI: Bool) {
        let realm = self.store
        realm?.beginWrite()
        realm?.delete(objects)
        realm?.commitWrite(notifyUI: notifyUI, errorListener: self.errorListener)
    }

    // MARK: - Insertions

    func insert(_ object: Object, notifyUI: Bool) {
        insert([object], notifyUI: notifyUI)
    }

    func insert(_ objects: [Object], notifyUI: Bool) {
        let realm = self.store
        realm?.beginWrite()
        realm?.add(objects, update: false)
        realm?.commitWrite(notifyUI: notifyUI, errorListener: self.errorListener)
    }
}

private extension Realm {

    func commitWrite(notifyUI: Bool, errorListener: ErrorListener?) {
        do {
            if notifyUI {
                try self.commitWrite()
                return
            }
            try self.commitWrite(withoutNotifying: DataStore.notificationTokens)
        } catch let error {
            errorListener?.dbRequestDidFail(with: error.localizedDescription, sender: self)
        }
    }
}
