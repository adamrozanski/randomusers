//
//  ImagesProvider.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit
import Gloss

protocol ImageProvidable: class {

    typealias SuccessHandlerType = (URL, UIImage) -> Void
    typealias FailureHandlerType = (String) -> Void


    func fetchImage(from remoteUrl: URL,
                    successHandler: @escaping SuccessHandlerType,
                    failureHandler: @escaping FailureHandlerType,
                    progressUpdateHandler: @escaping ProgressTrackable.ProgressUpdateHandlerType)

    func getCachedImage(for remoteUrl: URL?) -> UIImage?
    func cancelDownload(remoteUrl: URL)
    func clearCache()
}

class ImageProvider: NSObject, URLSessionDownloadDelegate, ImageProvidable {
    
//    internal static var shared = ImageProvider()
    private let responseQueue = OperationQueue()
    private lazy var stateQueue = DispatchQueue(label: "image_provider_state_queue", qos: .utility, attributes: .concurrent)
    private let mainQueue = DispatchQueue.main
    private var _activeDownloads: [URL: ImageDownloadTicket] = [:]
    private var activeDownloads: [URL: ImageDownloadTicket] {
        get { return stateQueue.sync { self._activeDownloads } }
        set (value) { stateQueue.async(flags: .barrier) { self._activeDownloads = value } }
    }

    private var _invalidImageUrls: [URL] = []
    private var invalidImageUrls: [URL] {
        get { return stateQueue.sync { self._invalidImageUrls } }
        set (value) { stateQueue.async(flags: .barrier) { self._invalidImageUrls = value } }
    }
    private let cachedFileExtension = ".imagecache"


    override init() {
        super.init()
        self.responseQueue.qualityOfService = .utility
        self.responseQueue.maxConcurrentOperationCount = 5
    }

    internal func fetchImage(from remoteUrl: URL,
                             successHandler: @escaping SuccessHandlerType,
                             failureHandler: @escaping FailureHandlerType,
                             progressUpdateHandler: @escaping ProgressTrackable.ProgressUpdateHandlerType) {

        if self.invalidImageUrls.contains(remoteUrl) {
            return
        }
        let ticket = ImageDownloadTicket(remoteUrl: remoteUrl, successHandler: successHandler, failureHandler: failureHandler, progressUpdateHandler: progressUpdateHandler)
        let session = SessionProvider.provideDownloadsSession(delegate: self, queue: self.responseQueue)
        var request = URLRequest(url: remoteUrl)
        request.httpMethod = "GET"
        ticket.task = session.downloadTask(with: request)
        ticket.task?.resume()
        activeDownloads[remoteUrl] = ticket
        mainQueue.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    internal func cancelDownload(remoteUrl: URL) {
        if let downloadTicket = activeDownloads[remoteUrl] {
            downloadTicket.cancel()
        }
    }

    internal func getCachedImage(for remoteUrl: URL?) -> UIImage? {
        if let remoteUrl = remoteUrl,
            let localUrl = self.localUrlForRemoteUrl(remoteUrl),
            let cachedImage = self.imageFromFile(atLocalUrl: localUrl) {
            return cachedImage
        }
        return nil
    }

    internal func clearCache() {
        do {
            try FileManager.removeAllFiles(withSuffix: self.cachedFileExtension, in: .cachesDirectory)
        } catch {
            NSLog("Could not clear caches directory: \(error.localizedDescription)")
        }
    }

    // MARK: URLSessionDownloadDelegate

    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        guard let ticket: ImageDownloadTicket = activeDownloadForTask(downloadTask) else { return }

        let remoteUrl = ticket.remoteUrl
        let downloadTicket: ImageDownloadTicket? = ticket

        let fileManager = FileManager.default

        mainQueue.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

        if let errorResponse = praseErrorResponse(at: location) {
            downloadTicket?.failureHandler(errorResponse.message)
            activeDownloads[remoteUrl] = nil
            try? fileManager.removeItem(at: location)
            return
        }

        guard let localUrl = self.localUrlForRemoteUrl(remoteUrl) else {
            downloadTicket?.failureHandler(Strings.invalidPath)
            activeDownloads[remoteUrl] = nil
            return
        }

        try? fileManager.removeItem(at: localUrl)

        do {
            try fileManager.copyItem(at: location, to: localUrl)
            if let image = self.imageFromFile(atLocalUrl: localUrl) {
                downloadTicket?.successHandler(remoteUrl, image)
            } else {
                self.invalidImageUrls.append(remoteUrl)
            }
            try? fileManager.removeItem(at: location)
            activeDownloads[remoteUrl] = nil

        } catch let error {
            downloadTicket?.failureHandler(error.localizedDescription)
            activeDownloads[remoteUrl] = nil
        }
    }

    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        guard let downloadTicket = activeDownloadForTask(task) else {
            return
        }

        let remoteUrl = downloadTicket.remoteUrl

        mainQueue.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

        if taskDidCancelWithError(error) {
            activeDownloads[remoteUrl] = nil
            return
        }

        if let error = error {
            downloadTicket.failureHandler(error.localizedDescription)
            activeDownloads[remoteUrl] = nil
            return
        }

        if let httpResponse = task.response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let message: String = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            downloadTicket.failureHandler(message)
            activeDownloads[remoteUrl] = nil
            return
        }

    }

    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        guard let downloadTicket = activeDownloadForTask(downloadTask) else {
            return
        }

        downloadTicket.updateProgress(totalBytesProceeded: totalBytesWritten, totalSizeInBytes: totalBytesExpectedToWrite)
    }

    // MARK: Utils

    private func activeDownloadForTask( _ task: URLSessionTask) -> ImageDownloadTicket? {
        var downloadTicket: ImageDownloadTicket?

        for ( _ , activeDownloadTicket) in activeDownloads {
            if let downloadTask = activeDownloadTicket.task, downloadTask === task {
                downloadTicket = activeDownloadTicket
            }
        }
        return downloadTicket
    }

    private func localUrlForRemoteUrl(_ remoteUrl: URL) -> URL? {
        let fileName = remoteUrl.lastPathComponent + cachedFileExtension
        let localUrl = URL.createUrl(with: fileName, in: .cachesDirectory)
        return localUrl
    }

    private func imageFromFile(atLocalUrl localUrl: URL) -> UIImage? {
        if let data = try? Data(contentsOf: localUrl), let image = UIImage(data: data) {
            return image
        }
        return nil
    }

    private func praseErrorResponse(at url: URL) -> ErrorResponse? {
        guard
            let data = try? Data(contentsOf: url),
            let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let json = dict as? JSON,
            let errorResponse = ErrorResponse(json: json)
            else { return nil }

        return errorResponse
    }

    private func taskDidCancelWithError(_ error: Error?) -> Bool {
        if let error = error, error.localizedDescription == "cancelled" {
            return true
        }
        return false
    }
}
