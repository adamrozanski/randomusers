//
//  UserPicker
//  Users
//
//  Created by Adam on 01/07/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

class UserPicker: UITableViewController {

    typealias CompletionHanler = ([User]) -> Void

    private let viewModel: UserPickerViewModelProtocol
    private let searchController = UISearchController(searchResultsController: nil)
    private var completionHandler: CompletionHanler?
    private var saveButtonItem: UIBarButtonItem?

    // MARK: - Initial section

    internal init(viewModel: UserPickerViewModelProtocol, completionHandler: CompletionHanler?) {
        self.viewModel = viewModel
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
        self.viewModel.setUpdateHandler(self.didUpdateData)
        self.viewModel.setErrorListener(self)
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        self.viewModel.setErrorListener(self)
        self.view.addSpinner(hidden: false)
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchController()
    }

    private func configureNavigationBar() {
        self.title = Strings.addUsers
        let cancelButtonItem = UIBarButtonItem(title: Strings.cancel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(UserPicker.dismissButtonDidTap))
        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.saveButtonItem = UIBarButtonItem(title: Strings.add, style: UIBarButtonItemStyle.done, target: self, action: #selector(UserPicker.saveButtonDidTap))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        setSaveButtonEnabled(self.viewModel.areUsersPicked)
    }

    private func configureTableView() {
        self.tableView.register(UserCell.getNib(), forCellReuseIdentifier: UserCell.cellId)
        self.tableView.separatorStyle = .none
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = UIColor.superLightGray
        searchBar.placeholder = Strings.search
        searchBar.scopeButtonTitles = [Strings.all, Strings.males, Strings.females]
        searchBar.setValue(Strings.cancel, forKey:"_cancelButtonText")
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.borderColor = UIColor.superLightGray.cgColor
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
    }

    private func setSaveButtonEnabled(_ isEnabled: Bool) {
        self.saveButtonItem?.isEnabled = isEnabled
    }

    private func fetchData() {
        DispatchQueue.main.async { [weak self] in
            self?.view.showSpinner()
        }
        self.viewModel.fetchUsers()
    }
    // MARK: - Handle model notifications

    func didUpdateData() {
        DispatchQueue.main.async { [weak self] in
            self?.view.hideSpinner()
            self?.tableView.reloadData()
        }
    }

    // MARK: - Handle user actions

    @objc func dismissButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonDidTap() {
        dismiss(animated: true) {
            let pickedUsers = self.viewModel.getPickedUsers()
            self.completionHandler?(pickedUsers)
        }
    }
}

// MARK: - UITableViewDataSource

extension UserPicker {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getUsers().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.cellId, for: indexPath) as! UserCell
        let user = self.viewModel.getUser(at: indexPath.row)
        let accesory: UITableViewCellAccessoryType = self.viewModel.isUserPicked(user) ? .checkmark : .none
        let url = user.imageUrls?.getUrl(for: .thumbnail)
        if let cachedImage = self.viewModel.getCachedImage(for: url) {
            cell.configure(with: user, imageUrl: nil, image: cachedImage, accessory: accesory)
        } else {
            let placeholder = self.viewModel.getUserPlaceholderImage()
            cell.configure(with: user, imageUrl: url, image: placeholder, accessory: accesory)
            tableView.provideImages(for: cell, at: indexPath, using: self.viewModel.getImageProvider())
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserPicker {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserCell.cellHeight
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.shouldFetchUsers(for: indexPath) {
            self.viewModel.fetchUsers()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel.getUser(at: indexPath.row)
        self.viewModel.togglePick(for: user)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        setSaveButtonEnabled(self.viewModel.areUsersPicked)
    }
}

extension UserPicker: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if let scope = FilterScope(rawValue: selectedScope) {
            self.viewModel.setFilterScope(scope)
            self.tableView.reloadData()
        }
    }
}

extension UserPicker: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.setFilterKey(searchController.searchBar.text)
        self.tableView.reloadData()
    }
}

extension UserPicker {

    internal static func pickUsers(in parent: UIViewController,
                                   with viewModel: UserPickerViewModelProtocol = UserPickerViewModel(usersProvider: UsersProvider(), imageProvider: ImageProvider()),
                                   completionHandler: @escaping CompletionHanler) {
        let picker = UserPicker(viewModel: viewModel, completionHandler: completionHandler)
        let navigationController = UINavigationController(rootViewController: picker)
        parent.present(navigationController, animated: true, completion: nil)
    }
}
