//
//  UserDetailsViewController.swift
//  Users
//
//  Created by Adam on 02/07/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    private let user: User
    private let imageProvider: ImageProvidable
    private let userPlaceholderIconName = "user-placeholder"

    @IBOutlet private weak var userImageView: RemoteImageView!
    //field titles
    @IBOutlet private weak var userNameTitleLabel: UILabel!
    @IBOutlet private weak var addressTitleLabel: UILabel!
    @IBOutlet private weak var emailTitleLabel: UILabel!
    @IBOutlet private weak var ageTitleLabel: UILabel!
    @IBOutlet private weak var registrationDateTitleLabel: UILabel!
    //field values
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var registrationDateLabel: UILabel!

    internal init(user: User, imageProvider: ImageProvidable) {
        self.user = user
        self.imageProvider = imageProvider
        super.init(nibName: "UserDetailsView", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Strings.details
        configureImageView()
        setFieldDescriptions()
        propagateUser(self.user)
        provideImages(using: self.imageProvider)
    }

    private func configureImageView() {
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.height / 2
    }

    private func propagateUser(_ user: User) {
        self.userNameLabel.text = user.name?.toFullNameString
        self.addressLabel.text = user.location?.toAddressString
        self.emailLabel.text = user.email
        self.ageLabel.text = "\(user.birthDateInfo?.age ?? 0)"
        self.registrationDateLabel.text = user.registrationDateInfo?.date?.toString(format: .readableDate,
                                                                                    locale: Locale(identifier: "pl_PL"))
        self.userImageView.image = UIImage(named: self.userPlaceholderIconName)
        self.userImageView.remoteUrl = user.imageUrls?.getUrl(for: .large)
    }

    private func setFieldDescriptions() {
        self.userNameTitleLabel.text = Strings.fullName
        self.addressTitleLabel.text = Strings.address
        self.emailTitleLabel.text = Strings.email
        self.ageTitleLabel.text = Strings.age
        self.registrationDateTitleLabel.text = Strings.registrationDate
    }
}

extension UserDetailsViewController: ImageDownloadable {

    internal var remoteImageViews: [RemoteImageView] {
        return [
            self.userImageView
        ]
    }

}
