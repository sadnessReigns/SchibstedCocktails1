//
//  SCNetworkClient.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation
import SCNetworkingProtocols
import SCCommon

public final class SCNetworkClient {
    private let session: SCURLSessionProtocol
    private let baseURL: URL
    private let cache: SCNetworkCacheProtocol

    public init(
        baseURL: URL,
        session: SCURLSessionProtocol = URLSession.shared,
        cache: SCNetworkCacheProtocol = SCNetworkCache()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.cache = cache
    }
}

// MARK: - SCNetworkClientProtocol

extension SCNetworkClient: SCNetworkClientProtocol {

    public func fetch<T: Decodable & Sendable>(
        _ endpoint: SCEndpoint,
        as type: T.Type
    ) async throws -> T {
        var request = SCRequestBuilder.buildRequest(baseURL: baseURL, endpoint: endpoint)

        if let creds: SCCredentials = try? SCKeychainStorageService().load(key: .userCredentials) {
            let loginString = "\(creds.username):\(creds.password)"
            if let loginData = loginString.data(using: .utf8) {
                let base64LoginString = loginData.base64EncodedString()
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            }
        }

        if let cached = await cache.get(for: request.url! as NSURL) {
            return try JSONDecoder().decode(T.self, from: cached)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw SCNetworkError.invalidResponse
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw SCNetworkError.serverError(httpResponse.statusCode)
            }

            await cache.store(data, for: request.url! as NSURL)

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw SCNetworkError.decodingError(error)
            }
        } catch {
            throw SCNetworkError.network(error)
        }
    }
}
