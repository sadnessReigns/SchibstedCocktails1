//
//  MockNetworkClient.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation
import SCNetworkingProtocols

final class MockNetworkClient: SCNetworkClientProtocol, @unchecked Sendable {
    private let fetchResult: Result<[SCCocktail], Error>

    init(fetchResult: Result<[SCCocktail], Error>) {
        self.fetchResult = fetchResult
    }

    func fetch<T>(_ endpoint: SCEndpoint, as type: T.Type) async throws -> T where T : Decodable {
        switch fetchResult {
        case .success(let cocktails):
            return cocktails as! T
        case .failure(let error):
            throw error
        }
    }
}

final class MockURLSession: SCURLSessionProtocol {
    let dataToReturn: Data?
    let responseToReturn: URLResponse?
    let errorToThrow: Error?

    init(dataToReturn: Data?, responseToReturn: URLResponse?, errorToThrow: Error? = nil) {
        self.dataToReturn = dataToReturn
        self.responseToReturn = responseToReturn
        self.errorToThrow = errorToThrow
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = errorToThrow {
            throw error
        }
        return (dataToReturn ?? Data(), responseToReturn ?? URLResponse())
    }
}

actor MockCache: SCNetworkCacheProtocol {
    var cacheStore: [NSURL: Data] = [:]

    func get(for key: NSURL) async -> Data? {
        return cacheStore[key]
    }

    func store(_ data: Data, for key: NSURL) async {
        cacheStore[key] = data
    }
}
