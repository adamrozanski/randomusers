//
//  ObjectResponseHandling.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Alamofire_Gloss
import Alamofire
import Gloss

internal protocol ObjectResponseHandling: HTTPResponseHandling {

    func requestDidCompleteWithSuccess(response: ResponseType?)
}

internal extension ObjectResponseHandling {

    internal func makeRequest() {
        self.isFetching = true
        dataRequest()
            .validate(statusCode: 200..<300)
            .responseObject(ResponseType.self, queue: self.getWorkerQueue()) { [weak self] responseData in
                switch responseData.result {
                case .success(let object):
                    self?.requestDidCompleteWithSuccess(response:object)
                case .failure(let error):
                    self?.handleError(error,
                                     response: responseData.response,
                                     responseData: responseData.data,
                                     errorListener: self?.errorListener)
                }
                self?.isFetching = false
        }
    }

}
