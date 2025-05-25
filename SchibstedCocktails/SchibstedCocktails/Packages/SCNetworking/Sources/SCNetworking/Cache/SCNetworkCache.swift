//
//  SCNetworkCache.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation
import SCNetworkingProtocols

public actor SCNetworkCache: SCNetworkCacheProtocol {
    private let cache = NSCache<NSURL, NSData>()

    public init() {}

    public func get(for url: NSURL) -> Data? {
        cache.object(forKey: url) as Data?
    }

    public func store(_ data: Data, for url: NSURL) {
        cache.setObject(data as NSData, forKey: url)
    }
}
