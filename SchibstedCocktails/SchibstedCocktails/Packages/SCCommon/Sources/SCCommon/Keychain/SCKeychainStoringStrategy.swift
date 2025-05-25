//
//  SCKeychainStoringStrategy.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

public protocol SCKeychainStoringStrategy {
    associatedtype SCKeychainStorableUnit: Codable

    func save(_ unit: SCKeychainStorableUnit) throws
    func load() throws -> SCKeychainStorableUnit?
}
