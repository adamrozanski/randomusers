//
//  UserCell
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    static var cellId = "UserCellId"
    static var cellHeight: CGFloat = 79

    @IBOutlet private weak var userImageView: RemoteImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!


    override internal func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.height / 2
    }

    internal func configure(with user: User,
                            imageUrl: URL?,
                            image: UIImage? = nil,
                            accessory: UITableViewCellAccessoryType = .disclosureIndicator) {

        self.userNameLabel.text = user.name?.toFullNameString
        self.addressLabel.text = user.location?.toAddressString
        self.userImageView.image = image
        self.userImageView.remoteUrl = imageUrl
        self.accessoryType = accessory
    }
}

extension UserCell: ImageDownloadable {

    internal var remoteImageViews: [RemoteImageView] {
        return [
            userImageView
        ]
    }
}

extension UserCell {

    static func getNib() -> UINib {
        return UINib(nibName: "UserCell", bundle: nil)
    }
}
