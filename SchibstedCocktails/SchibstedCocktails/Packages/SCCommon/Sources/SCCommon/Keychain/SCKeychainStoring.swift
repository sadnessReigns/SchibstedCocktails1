//
//  SCKeychainStoring.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

public protocol SCKeychainStoring {
    func save<S: SCKeychainStoringStrategy>(_ item: S.SCKeychainStorableUnit, using strategy: S) throws
    func load<S: SCKeychainStoringStrategy>(using strategy: S) throws -> S.SCKeychainStorableUnit?
}

