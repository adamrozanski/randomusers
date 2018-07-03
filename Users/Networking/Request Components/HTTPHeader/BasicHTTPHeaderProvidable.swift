//
//  BasicHTTPHeaderProvidable
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol BasicHTTPHeaderProvidable: HTTPHeaderProvidable {}

extension BasicHTTPHeaderProvidable {

    func headers() -> HTTPHeaders {
        return [
            Constants.HTTPHeaderKey.contentType : Constants.ContentType.JSON
        ]
    }

}
