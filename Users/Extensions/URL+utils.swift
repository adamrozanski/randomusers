//
//  URL+utils.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

extension URL {

    static func createUrl(with fileName: String, in directory: FileManager.SearchPathDirectory) -> URL? {
        guard let directoryURL = FileManager.directoryUrl(for: directory) else {
            return nil
        }
        return directoryURL.appendingPathComponent(fileName)
    }

}
