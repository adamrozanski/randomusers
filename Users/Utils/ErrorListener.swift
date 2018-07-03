//
//  ErrorListener.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol ErrorListener: class {

    func dbRequestDidFail(with message: String, sender: Any?)
    func apiRequestDidFail(with message: String, sender: Any?)
    func apiRequestUnauthenticated()
}

extension ErrorListener {

    func apiRequestUnauthenticated() {}
}
