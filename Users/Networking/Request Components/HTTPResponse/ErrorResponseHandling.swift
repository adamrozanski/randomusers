//
//  ErrorResponseHandling.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Gloss
import Alamofire

protocol ErrorResponseHandling: class {

    func handleError(_ error: Error, response: HTTPURLResponse?, responseData: Data?, errorListener: ErrorListener?)
}

extension ErrorResponseHandling {

    func handleError(_ error: Error, response: HTTPURLResponse?, responseData: Data?, errorListener: ErrorListener?) {
        guard let response = response, let data = responseData else {
            handleErrorCode(-1, message: Strings.serverCommunicationError, apiListener: errorListener)
            return
        }
        if let errorResponse = parseErrorResponse(from: data) {
            handleErrorCode(response.statusCode, message: errorResponse.message, apiListener: errorListener)
            return
        }
        handleErrorCode(response.statusCode, message: error.localizedDescription, apiListener: errorListener)
    }

    private func handleErrorCode(_ errorCode: Int, message: String, apiListener: ErrorListener?) {
        switch errorCode {
        case Constants.HTTPStatusCode.unauthenticated:
            apiListener?.apiRequestUnauthenticated()
        default:
            apiListener?.apiRequestDidFail(with: message + " (http status \(errorCode))", sender: self)
        }
    }

    private func parseErrorResponse(from data: Data?) -> ErrorResponse? {
        guard
            let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any> else {
                return nil
        }
        return ErrorResponse(json: json)
    }
}
