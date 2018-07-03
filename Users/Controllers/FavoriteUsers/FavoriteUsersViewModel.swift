//
//  LocalUsersListViewModel.swift
//  Users
//
//  Created by Adam on 01/07/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import RealmSwift
import UIKit

protocol FavoriteUsersViewModelProtocol: class {

    typealias DataLoadHandler = () -> Void
    typealias DataUpdateHandler = (_ deletions: [IndexPath], _ insertions: [IndexPath], _ modifications: [IndexPath]) -> Void

    func loadUsers()
    func getUsers() -> Results<User>?
    func getUser(at index: Int) -> User?
    func delete(user: User)
    func add(users: [User])
    func setHandlers(onDataLoad: DataLoadHandler?, onDataUpdate: DataUpdateHandler?)
    func setErrorListener(_ errorListener: UIViewController)

    func getImageProvider() -> ImageProvidable
    func getUserPlaceholderImage() -> UIImage
    func getCachedImage(for url: URL?) -> UIImage?
}

class FavoriteUsersViewModel: NSObject, FavoriteUsersViewModelProtocol {

    private var dataStore: DataStorable
    private let imageProvider: ImageProvidable
    private var notificationToken: NotificationToken? = nil
    private weak var errorListener: UIViewController?

    private var onDataLoad: DataLoadHandler?
    private var onDataUpdate: DataUpdateHandler?

    private var users: Results<User>?

    private lazy var userPlaceholderImage: UIImage = {
        return UIImage(named: "user-placeholder")!
    }()

    internal init(dataStore: DataStorable, imageProvider: ImageProvidable) {
        self.dataStore = dataStore
        self.imageProvider = imageProvider
    }

    deinit {
        self.notificationToken?.invalidate()
        self.dataStore.removeNotification(notificationToken)
    }

    internal func setHandlers(onDataLoad: DataLoadHandler?, onDataUpdate: DataUpdateHandler?) {
        self.onDataLoad = onDataLoad
        self.onDataUpdate = onDataUpdate
    }

    func setErrorListener(_ errorListener: UIViewController) {
        self.errorListener = errorListener
        self.dataStore.setErrorListener(errorListener)
    }

    internal func loadUsers() {
        let users = self.dataStore.fetchUsers()
        self.users = users
        registerNotifications(for: users)
    }

    func getUsers() -> Results<User>? {
        return self.users
    }

    func getUser(at index: Int) -> User? {
        return self.users?[index]
    }

    func add(users: [User]) {
        self.dataStore.insert(users, notifyUI: true)
    }

    func delete(user: User) {
        self.dataStore.delete(user, notifyUI: false)
    }

    internal func getCachedImage(for url: URL?) -> UIImage? {
        return self.imageProvider.getCachedImage(for: url)
    }

    internal func getImageProvider() -> ImageProvidable {
        return self.imageProvider
    }

    internal func getUserPlaceholderImage() -> UIImage {
        return userPlaceholderImage
    }

    private func registerNotifications(for users: Results<User>?) {
        self.notificationToken = users?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.onDataLoad?()
            case .update(_, let deletions, let insertions, let modifications):
                let deletions = deletions.map({ IndexPath(row: $0, section: 0) })
                let insertions = insertions.map({ IndexPath(row: $0, section: 0) })
                let modifications = modifications.map({ IndexPath(row: $0, section: 0) })
                self?.onDataUpdate?(deletions, insertions, modifications)
            case .error(let error):
                self?.errorListener?.dbRequestDidFail(with: error.localizedDescription, sender: self)
            }
        }
        self.dataStore.registerNotification(notificationToken)
    }
}
