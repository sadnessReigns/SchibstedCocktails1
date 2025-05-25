//
//  SCEndpoint.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation

public enum SCMethod: String, Sendable {
    case get = "GET"
}

public struct SCEndpoint: Sendable {
    public let path: String
    public let method: SCMethod
    public let queryItems: [URLQueryItem]?
    public let headers: [String: String]?

    public init(
        path: String,
        method: SCMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
    }
}
