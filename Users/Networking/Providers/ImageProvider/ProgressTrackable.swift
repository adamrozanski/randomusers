//
//  ProgressTrackable.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol ProgressTrackable: class {

    typealias ProgressUpdateHandlerType = (_ progress: Float, _ totalBytesProceededFormatted: String, _ totalSizeFormatted: String, _ bytesProceeded: Int64) -> Void
    
    var progress: Float { get set }
    var totalBytesProceeded: Int64 { get set }
    var totalSizeInBytes: Int64 { get set }
    var progressUpdateHandler: ProgressUpdateHandlerType { get set }

    func updateProgress(totalBytesProceeded: Int64, totalSizeInBytes: Int64)
}

extension ProgressTrackable {

    private var progressAdvanceForUnknownSize: Float {
        return 1.0
    }

    internal var totalBytesProceededFormatted: String {
        return ByteCountFormatter.string(fromByteCount: totalSizeInBytes, countStyle: .binary)
    }

    internal var totalSizeFormatted: String {
        if totalSizeInBytes == -1 { return "?" }
        return ByteCountFormatter.string(fromByteCount: totalSizeInBytes, countStyle: .binary)
    }

    internal func updateProgress(totalBytesProceeded: Int64, totalSizeInBytes: Int64) {
        self.progress = totalSizeInBytes == -1 ? progressAdvanceForUnknownSize : Float(totalBytesProceeded)/Float(totalSizeInBytes)
        if progress < 0.001 { progress = 0.0 }
        self.totalBytesProceeded = totalBytesProceeded
        self.totalSizeInBytes = totalSizeInBytes
        progressUpdateHandler(progress, totalBytesProceededFormatted, totalSizeFormatted, totalBytesProceeded)
    }
}
