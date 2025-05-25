//
//  SCKeychain.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//


import Foundation
import Security

public protocol SCKeychainProtocol {
    func add(_ query: CFDictionary) -> OSStatus
    func delete(_ query: CFDictionary) -> OSStatus
    func copyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<AnyObject?>) -> OSStatus
}

public final class SCKeychain: SCKeychainProtocol {
    public init() {}

    @discardableResult
    public func add(_ query: CFDictionary) -> OSStatus {
        SecItemAdd(query, nil)
    }

    @discardableResult
    public func delete(_ query: CFDictionary) -> OSStatus {
        SecItemDelete(query)
    }

    public func copyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<AnyObject?>) -> OSStatus {
        SecItemCopyMatching(query, result)
    }
}
