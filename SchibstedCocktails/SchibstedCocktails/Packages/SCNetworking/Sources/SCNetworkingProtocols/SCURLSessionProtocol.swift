//
//  SCURLSessionProtocol.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation

public protocol SCURLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: SCURLSessionProtocol {}
