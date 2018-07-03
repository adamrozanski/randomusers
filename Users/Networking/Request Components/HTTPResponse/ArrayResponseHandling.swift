//
//  ArrayResponseHandling.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Alamofire_Gloss
import Alamofire
import Gloss

internal protocol ArrayResponseHandling: HTTPResponseHandling {

    func requestDidCompleteWithSuccess(response: [ResponseType]?)
}

internal extension ArrayResponseHandling {

    internal func makeRequest() {
        self.isFetching = true
        dataRequest()
            .validate(statusCode: 200..<300)
            .responseArray(ResponseType.self, queue: self.getWorkerQueue()) { [weak self] responseData in
                switch responseData.result {
                case .success(let objectsArray):
                    self?.requestDidCompleteWithSuccess(response:objectsArray)
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
