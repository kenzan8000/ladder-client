//
//    LDRTestURLProtocol.swift
//    ladder-client
//
//    Created by Kenzan Hase on 12/30/21.
//    Copyright © 2021 kenzan8000. All rights reserved.
//

import Foundation

// MARK: - LDRTestURLProtocol
class LDRTestURLProtocol: URLProtocol {
    // MARK: static property
    
    static var requests = [URLRequest]()
    
    // MARK: URLProtocol

    override class func canInit(with request: URLRequest) -> Bool {
        requests.append(request)
        return false
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        //do nothing
    }

    override func stopLoading() {
        //do nothing
    }
}
