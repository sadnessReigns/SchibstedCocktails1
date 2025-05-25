//
//  SCNetworkCacheProtocol.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation

public protocol SCNetworkCacheProtocol: Sendable {
    func get(for url: NSURL) async -> Data?
    func store(_ data: Data, for url: NSURL) async
}
