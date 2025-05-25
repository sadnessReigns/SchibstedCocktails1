//
//  SCKeychainService.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

public final class SCKeychainService: SCKeychainStoring {

    public func save<S>(_ unit: S.SCKeychainStorableUnit, using strategy: S) throws where S : SCKeychainStoringStrategy {
        try strategy.save(unit)
    }

    public func load<S>(using strategy: S) throws -> S.SCKeychainStorableUnit? where S : SCKeychainStoringStrategy {
        try strategy.load()
    }

    public init() {}
}
