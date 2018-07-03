//
//  ImageDownloadable
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

protocol ImageDownloadable: class {

    var photoFadeInDuration: TimeInterval { get }
    var remoteImageViews: [RemoteImageView] { get }

    func update(with remoteUrl: URL?, image: UIImage, animated: Bool)
    func update(imageView: RemoteImageView, with image: UIImage, animated: Bool)

    func provideImages(using imageProvider: ImageProvidable?, onImageProvided: (ImageProvidable.SuccessHandlerType)?)

}

extension ImageDownloadable {

    var photoFadeInDuration: TimeInterval {
        return 0.6
    }

    internal func update(with remoteUrl: URL?, image: UIImage, animated: Bool) {
        if let remoteUrl = remoteUrl,
            let imageView = self.remoteImageViews.filter({ $0.remoteUrl == remoteUrl }).first {
                update(imageView: imageView, with: image, animated: animated)
        }
    }

    internal func update(imageView: RemoteImageView, with image: UIImage, animated: Bool) {
        DispatchQueue.main.async {
            if animated {
                UIView.transition(with: imageView,
                                  duration: self.photoFadeInDuration,
                                  options: .transitionCrossDissolve,
                                  animations: { imageView.image = image },
                                  completion: nil)
                return
            }
            imageView.image = image
        }
    }

    internal func provideImages(using imageProvider: ImageProvidable?, onImageProvided: (ImageProvidable.SuccessHandlerType)? = nil) {
        guard let imageProvider = imageProvider else {
            return
        }
        for imageView in self.remoteImageViews {
            guard let remoteUrl = imageView.remoteUrl else {
                continue
            }
            if let image = imageProvider.getCachedImage(for: remoteUrl) {
                self.update(imageView: imageView, with: image, animated: false)
                onImageProvided?(remoteUrl, image)
            } else {
                self.fetchImage(from: remoteUrl, using: imageProvider, onImageProvided: onImageProvided)
            }
        }
    }

    private func fetchImage(from remoteUrl: URL?, using imageProvider: ImageProvidable?, onImageProvided: (ImageProvidable.SuccessHandlerType)? = nil) {
        if let remoteUrl = remoteUrl {
            imageProvider?.fetchImage(from: remoteUrl, successHandler: { [weak self] remoteUrl, image in
                self?.updateImage(withRemoteUrl: remoteUrl, with: image)
                onImageProvided?(remoteUrl, image)
                }, failureHandler: { (message) in
                    NSLog(message)
            }, progressUpdateHandler: { (_, _, _, _) in })
        }
    }

    private func updateImage(withRemoteUrl remoteUrl: URL?, with image: UIImage) {
        DispatchQueue.main.async {
            self.update(with: remoteUrl, image: image, animated: true)
        }
    }
}

