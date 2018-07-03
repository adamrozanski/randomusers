//
//  HTTPHeaderProvidable
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol HTTPHeaderProvidable: class {

    typealias HTTPHeaders = Dictionary<String, String>

    func headers() -> HTTPHeaders
}
