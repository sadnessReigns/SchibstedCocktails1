//
//  SCKeychainStorageKey.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 25.05.25.
//

public extension SCKeychainKey {

    static let userCredentials: Self = .init("userCredentials.key")
}

public struct SCKeychainKey: Identifiable, Sendable {

    fileprivate init(_ id: String) {
        self.id = id
    }

    private(set) public var id: String
}
