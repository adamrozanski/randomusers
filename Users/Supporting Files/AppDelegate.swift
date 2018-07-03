//
//  AppDelegate.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        presentInitialViewController(in: self.window!)
        return true
    }

    private func presentInitialViewController(in window: UIWindow) {
        let dataStore = DataStore(storeProvider: DefaultDataStoreProvider())
        let viewModel = FavoriteUsersViewModel(dataStore: dataStore, imageProvider: ImageProvider())
        let controller = FavoriteUsersViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: controller)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
