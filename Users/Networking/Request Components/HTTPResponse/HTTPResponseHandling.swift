//
//  HTTPResponseHandling
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation
import Gloss

internal protocol HTTPResponseHandling: HTTPRequestProvidable, ErrorResponseHandling {

    associatedtype ResponseType: JSONDecodable

    var isFetching: Bool { get set }
    var errorListener: ErrorListener? { get set }

    func makeRequest()
    func makeAsyncRequest()
    func setErrorListener(_ listener: ErrorListener?)
    func getWorkerQueue() -> DispatchQueue
}

extension HTTPResponseHandling {

    var isFetching: Bool {
        return false
    }

    var errorListener: ErrorListener? {
        return nil
    }

    func setErrorListener(_ listener: ErrorListener?) {
        self.errorListener = listener
    }

    func getWorkerQueue() -> DispatchQueue {
        return DispatchQueue.global(qos: .userInitiated)
    }

    func makeAsyncRequest() {
        self.getWorkerQueue().async { [weak self] in
            self?.makeRequest()
        }
    }

}
