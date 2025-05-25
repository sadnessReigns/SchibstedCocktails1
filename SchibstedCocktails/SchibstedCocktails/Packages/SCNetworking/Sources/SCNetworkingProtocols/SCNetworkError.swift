//
//  SCNetworkError.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation

public enum SCNetworkError: Error {
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case network(Error)
}
