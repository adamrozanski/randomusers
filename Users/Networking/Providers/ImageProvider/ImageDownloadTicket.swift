//
//  ImageDownloadTicket.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

class ImageDownloadTicket: ProgressTrackable {

    internal var remoteUrl: URL
    internal var task: URLSessionDownloadTask?

    internal var progress: Float = 0.0
    internal var totalBytesProceeded: Int64 = 0
    internal var totalSizeInBytes: Int64 = 0
    internal var progressUpdateHandler: ProgressUpdateHandlerType

    internal var successHandler: ImageProvider.SuccessHandlerType
    internal var failureHandler: ImageProvider.FailureHandlerType

    internal init(remoteUrl: URL,
                  successHandler: @escaping ImageProvider.SuccessHandlerType,
                  failureHandler: @escaping ImageProvider.FailureHandlerType,
                  progressUpdateHandler: @escaping ProgressUpdateHandlerType) {

        self.remoteUrl = remoteUrl
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        self.progressUpdateHandler = progressUpdateHandler
    }

    internal func cancel() {
        task?.cancel()
    }

}
