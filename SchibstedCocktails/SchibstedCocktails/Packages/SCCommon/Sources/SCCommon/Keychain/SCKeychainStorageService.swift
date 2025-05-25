//
//  SCKeychainStorageService.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation

public class SCKeychainStorageService: SCKeychainStorageServiceProtocol {

    private let keychain: SCKeychainProtocol

    public init(keychain: SCKeychainProtocol = SCKeychain()) {
        self.keychain = keychain
    }

    public func save<S: Encodable>(_ unit: S, key: SCKeychainKey) throws {
        guard let data = try? JSONEncoder().encode(unit) else {
            throw SCKeychainError.encodingFailed
        }

        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : key.id,
            kSecValueData as String   : data
        ]

        keychain.delete(query as CFDictionary)
        let status = keychain.add(query as CFDictionary)
        guard status == errSecSuccess else {
            throw SCKeychainError.saveFailed(status: status)
        }
    }

    public func load<S: Decodable>(key: SCKeychainKey, as type: S.Type = S.self) throws -> S {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : key.id,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = keychain.copyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess else { throw SCKeychainError.loadFailed }
        guard let data = dataTypeRef as? Data,
              let creds = try? JSONDecoder().decode(S.self, from: data) else {
            throw SCKeychainError.decodeFailed
        }

        return creds
    }
}
