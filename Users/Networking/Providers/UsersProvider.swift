//
//  UsersProvider.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol UsersProvidable: GETRequestProvidable & BasicHTTPHeaderProvidable & ObjectResponseHandling {
    func fetchUsers(page: Page)
}

protocol UsersProviderDelegate: class {
    func provider(_ provider: UsersProvider, didFetchUsers users: [User], page: Page)
}

class UsersProvider: UsersProvidable {
    
    typealias ResponseType = UsersResponse

    internal weak var delegate: UsersProviderDelegate?
    internal weak var errorListener: ErrorListener?
    internal var isFetching: Bool = false
    private var page: Page?

    func fetchUsers(page: Page = Page.initialPage()) {
        self.page = page
        makeAsyncRequest()
    }

    func endpointPath() -> String? {
        return "\(self.apiConfiguration().apiVersion)/"
    }

    func queryItems() -> [URLQueryItem]? {
        return self.page?.toQueryItems()
    }

    // MARK: ObjectResponseHandling

    func requestDidCompleteWithSuccess(response: UsersResponse?) {
        if let users = response?.users, let page = response?.page {
            delegate?.provider(self, didFetchUsers: users, page: page )
        }
    }
}
