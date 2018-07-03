//
//  GETRequestProvidable
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Alamofire

internal protocol GETRequestProvidable: HTTPRequestProvidable {}

internal extension GETRequestProvidable {

    internal func method() -> HTTPMethod {
        return .get
    }

    func parameterEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
}
