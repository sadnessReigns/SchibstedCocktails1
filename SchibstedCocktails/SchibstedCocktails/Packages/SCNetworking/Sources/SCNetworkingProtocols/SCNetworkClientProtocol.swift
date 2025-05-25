//
//  SCNetworkClientProtocol.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

public protocol SCNetworkClientProtocol: Sendable {
    func fetch<T: Decodable>(
        _ endpoint: SCEndpoint,
        as type: T.Type
    ) async throws -> T
}
