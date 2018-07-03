//
//  HTTPRequestProvidable
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Alamofire

internal protocol HTTPRequestProvidable: URLQueryProvidable, HTTPHeaderProvidable, HTTPBodyProvidable {

    func method() -> HTTPMethod
    func parameterEncoding() -> ParameterEncoding

    func dataRequest() -> DataRequest
}

internal extension HTTPRequestProvidable {

    func dataRequest() -> DataRequest {
        return Alamofire.request(absoluteURL, method: method(), parameters: body(), encoding: parameterEncoding(), headers: headers())
    }
}
