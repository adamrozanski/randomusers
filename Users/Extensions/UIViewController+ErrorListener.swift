//
//  UIViewController+ErrorListener.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

extension UIViewController: ErrorListener {

    func dbRequestDidFail(with message: String, sender: Any?) {
        DispatchQueue.main.async {
            self.view.hideSpinner()
            self.presentAlert(withTitle: Strings.errorTitle, message: message)
        }
    }

    func apiRequestDidFail(with message: String, sender: Any?) {
        DispatchQueue.main.async {
            self.view.hideSpinner()
            self.presentAlert(withTitle: Strings.errorTitle, message: message)
        }
    }
}
