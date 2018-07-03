//
//  UserPickerViewModel
//  Users
//
//  Created by Adam on 01/07/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

enum FilterScope: Int {
    case all = 0
    case male
    case female
}

protocol UserPickerViewModelProtocol: class {

    typealias DataUpdateHandler = () -> Void

    var areUsersPicked: Bool { get }
    func isUserPicked(_ user: User) -> Bool
    func getPickedUsers() -> [User]
    func togglePick(for user: User)

    func fetchUsers()
    func shouldFetchUsers(for indexPath: IndexPath) -> Bool
    func getUsers() -> [User]
    func getUser(at index: Int) -> User
    func setUpdateHandler(_ onDataUpdate: DataUpdateHandler?)
    func setErrorListener(_ errorListener: UIViewController)
    func setFilterScope(_ scope: FilterScope)
    func setFilterKey(_ key: String?)

    func getImageProvider() -> ImageProvidable
    func getUserPlaceholderImage() -> UIImage
    func getCachedImage(for url: URL?) -> UIImage?
}

class UserPickerViewModel: NSObject, UserPickerViewModelProtocol {

    private let usersPerPage: UInt = 100
    private let nextFetchOnRowsRemaining: UInt = 30

    internal var onDataUpdate: DataUpdateHandler?
    private var usersProvider: UsersProvider
    private let imageProvider: ImageProvidable

    private var currentPage: Page?
    private var users: [User] = [] {
        didSet {
            self.onDataUpdate?()
        }
    }
    private var filterKey: String?
    private var fileterScope: FilterScope = .all

    private var scopedUsers: [User] {
        switch fileterScope {
        case .all: return users
        case .male: return users.filter { $0.getSex() == .male }
        case .female: return users.filter { $0.getSex() == .female }
        }
    }
    internal var filteredUsers: [User] {
        if let filterKey = self.filterKey, !filterKey.isEmpty {
            return scopedUsers.filter({ $0.contains(searchKey: filterKey) })
        }
        return scopedUsers
    }
    private var pickedUsers: [User] = []
    internal var areUsersPicked: Bool { return !pickedUsers.isEmpty }

    private lazy var userPlaceholderImage: UIImage = {
        return UIImage(named: "user-placeholder")!
    }()


    internal init(usersProvider: UsersProvider, imageProvider: ImageProvidable) {
        self.imageProvider = imageProvider
        self.usersProvider = usersProvider
        super.init()
        Page.defaultResultsCount = self.usersPerPage
    }

    internal func fetchUsers() {
        self.usersProvider.delegate = self
        self.usersProvider.fetchUsers(page: self.getNextPage())
    }

    internal func shouldFetchUsers(for indexPath: IndexPath) -> Bool {
        let rowsLoaded = self.users.count
        let rowsRemaining = rowsLoaded - indexPath.row
        return !self.isFetchingUsers && rowsRemaining <= self.nextFetchOnRowsRemaining
    }


    internal func setFilterKey(_ key: String?) {
        self.filterKey = key
    }

    internal func setFilterScope(_ scope: FilterScope) {
        self.fileterScope = scope
    }

    internal func setUpdateHandler(_ onDataUpdate: DataUpdateHandler?) {
        self.onDataUpdate = onDataUpdate
    }

    internal func setErrorListener(_ errorListener: UIViewController) {
        self.usersProvider.setErrorListener(errorListener)
    }

    internal func getUser(at index: Int) -> User {
        return self.filteredUsers[index]
    }

    internal func getUsers() -> [User] {
        return filteredUsers
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

    internal func getPickedUsers() -> [User] {
        return pickedUsers
    }

    internal func isUserPicked(_ user: User) -> Bool {
        return self.pickedUsers.contains(user)
    }

    internal func togglePick(for user: User) {
        self.isUserPicked(user) ? unpickUser(user) : pickUser(user)
    }

    private func pickUser(_ user: User) {
        self.pickedUsers.append(user)
    }

    private func unpickUser(_ user: User) {
        if let idx = pickedUsers.index(of: user) {
            pickedUsers.remove(at: idx)
        }
    }

    private func getNextPage() -> Page {
        return currentPage == nil ? Page.initialPage() : currentPage!.next()
    }

    private var isFetchingUsers: Bool {
        return self.usersProvider.isFetching
    }
}

extension UserPickerViewModel: UsersProviderDelegate {

    internal func provider(_ provider: UsersProvider, didFetchUsers users: [User], page: Page) {
        self.currentPage = page
        self.users += users
        self.onDataUpdate?()
    }
}
