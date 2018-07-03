//
//  HTTPBodyProvidable
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Gloss

protocol HTTPBodyProvidable: class {

    func body() -> JSON?
}

extension HTTPBodyProvidable {

    func body() -> JSON? {
        return nil
    }
}
