//
//  ViewController.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

class FavoriteUsersViewController: UITableViewController {

    private let viewModel: FavoriteUsersViewModelProtocol

    // MARK: - Initial section

    internal init(viewModel: FavoriteUsersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.setHandlers(onDataLoad: self.didLoadData, onDataUpdate: self.didUpdateData)
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureNavigationBar() {
        self.title = Strings.favoriteUsers
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FavoriteUsersViewController.addUsers))
        self.navigationItem.rightBarButtonItem = addButtonItem
    }

    private func configureTableView() {
        self.tableView.register(UserCell.getNib(), forCellReuseIdentifier: UserCell.cellId)
        self.tableView.separatorStyle = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        self.viewModel.setErrorListener(self)
        self.viewModel.loadUsers()
    }

    // MARK: - Handle model notifications

    func didLoadData() {
        self.tableView.reloadData()
    }

    func didUpdateData(_ deletions: [IndexPath], _ insertions: [IndexPath], _ modifications: [IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: insertions, with: .automatic)
        self.tableView.deleteRows(at: deletions, with: .automatic)
        self.tableView.reloadRows(at: modifications, with: .automatic)
        self.tableView.endUpdates()
    }

    // MARK: - Handle user actions

    @objc private func addUsers() {
        UserPicker.pickUsers(in: self) { [weak self] users in
            self?.viewModel.add(users: users)
        }
    }

    private func presentDetails(for user: User) {
        let imageProvider = ImageProvider()
        let controller = UserDetailsViewController(user: user, imageProvider: imageProvider)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getUsers()?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.cellId, for: indexPath) as! UserCell
        let user = self.viewModel.getUser(at: indexPath.row)!
        let url = user.imageUrls?.getUrl(for: .thumbnail)
        if let cachedImage = self.viewModel.getCachedImage(for: url) {
            cell.configure(with: user, imageUrl: nil, image: cachedImage)
        } else {
            let placeholder = self.viewModel.getUserPlaceholderImage()
            cell.configure(with: user, imageUrl: url, image: placeholder)
            tableView.provideImages(for: cell, at: indexPath, using: self.viewModel.getImageProvider())
        }
        return cell
    }



    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = self.viewModel.getUser(at: indexPath.row)!
            self.viewModel.delete(user: user)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserCell.cellHeight
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ImageDownloadable {
            tableView.provideImages(for: cell, at: indexPath, using: self.viewModel.getImageProvider())
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel.getUser(at: indexPath.row)!
        presentDetails(for: user)
    }
}
