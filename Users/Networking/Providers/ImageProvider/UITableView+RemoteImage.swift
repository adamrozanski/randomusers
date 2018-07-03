//
//  UITableView+RemoteImage.swift
//  Users
//
//  Created by Adam on 01/07/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

extension UITableView {

    internal func provideImages(for view: ImageDownloadable, at indexPath: IndexPath, using imageProvider: ImageProvidable, onImageProvided: (ImageProvider.SuccessHandlerType)? = nil) {
        for imageView in view.remoteImageViews {
            guard let remoteUrl = imageView.remoteUrl else {
                continue
            }
            if let image = imageProvider.getCachedImage(for: remoteUrl) {
                view.update(imageView: imageView, with: image, animated: false)
                onImageProvided?(remoteUrl, image)
            } else {
                self.fetchImage(forCellAt: indexPath, from: remoteUrl, using: imageProvider, onImageProvided: onImageProvided)
            }
        }
    }

    private func fetchImage(forCellAt indexPath: IndexPath, from remoteUrl: URL?, using imageProvider: ImageProvidable?, onImageProvided: (ImageProvider.SuccessHandlerType)? = nil) {
        if let remoteUrl = remoteUrl {
            imageProvider?.fetchImage(from: remoteUrl, successHandler: { [weak self] remoteUrl, image in
                self?.updateImage(withRemoteUrl: remoteUrl, inCellAt: indexPath, with: image)
                onImageProvided?(remoteUrl, image)
                }, failureHandler: { (message) in
                    NSLog(message)
            }, progressUpdateHandler: { (_, _, _, _) in })
        }
    }

    private func updateImage(withRemoteUrl remoteUrl: URL?, inCellAt indexPath: IndexPath, with image: UIImage) {
        DispatchQueue.main.async {
            if let cell = self.cellForRow(at: indexPath) as? ImageDownloadable, self.visibleCells.contains(cell as! UITableViewCell) {
                cell.update(with: remoteUrl, image: image, animated: true)
            }
        }
    }

}
