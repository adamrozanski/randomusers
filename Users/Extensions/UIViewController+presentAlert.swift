//
//  UIViewController.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlert(withTitle title: String, message: String, showCancelButton: Bool = false, okAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: {
            (action: UIAlertAction!) in
            if let okAction = okAction {
                okAction()
            }
        }))
        if showCancelButton {
            alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
}
