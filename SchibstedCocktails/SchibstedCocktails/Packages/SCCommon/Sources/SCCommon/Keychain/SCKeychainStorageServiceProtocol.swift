//
//  SCKeychainStorageServiceProtocol.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

public protocol SCKeychainStorageServiceProtocol {
    func save<Storable: Encodable>(_ unit: Storable, key: SCKeychainKey) throws
    func load<Storable: Decodable>(key: SCKeychainKey, as type: Storable.Type) throws -> Storable
}
