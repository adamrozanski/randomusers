//
//  SearchFieldsProvider.swift
//  Users
//
//  Created by Adam on 01/07/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol SearchFieldsProviding {

    var searchFields: [String] { get }

    func contains(searchKey: String) -> Bool
}

extension SearchFieldsProviding {

    internal func contains(searchKey: String) -> Bool {
        return getSearchFieldsString().lowercased().contains(searchKey.lowercased())
    }

    private func getSearchFieldsString() -> String {
        return searchFields.joined(separator: " ")
    }
}
