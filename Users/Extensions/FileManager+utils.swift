//
//  FileManager+utils.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

extension FileManager {

    static func directoryUrl(for directory: SearchPathDirectory) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: directory, in: .userDomainMask)
        return urls.first
    }

    static func sizeOfFile(url:URL) -> UInt64? {
        let filePath = url.path
        if let attr = try? FileManager.default.attributesOfItem(atPath: filePath) {
            let fileSize: UInt64 = attr[FileAttributeKey.size] as! UInt64
            return fileSize
        }
        return nil
    }

    static func removeAllFiles(withSuffix suffix: String, in directory: SearchPathDirectory) throws {
        let fileManager = FileManager.default
        guard let cachesDirectoryUrl = FileManager.directoryUrl(for: directory) else {
            return
        }
        let cachesDirectoryPath = cachesDirectoryUrl.path

        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: cachesDirectoryPath)
            for filePath in filePaths {
                if filePath.hasSuffix(suffix) {
                    try fileManager.removeItem(atPath: cachesDirectoryPath + "/" + filePath)
                }
            }
        }
    }
}
