//
//  SCCredentialsStoringStrategy.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Foundation

public class SCCredentialsStoringStrategy: SCKeychainStoringStrategy {
    public typealias SCKeychainStorableUnit = SCCredentials
    private let key: String
    private let keychain: SCKeychainProtocol

    public init(
        key: String = "SCCredentialsStoringStrategy.key",
        keychain: SCKeychainProtocol = SCKeychain()
    ) {
        self.key = key
        self.keychain = keychain
    }

    public func save(_ unit: SCKeychainStorableUnit) throws {
        guard let data = try? JSONEncoder().encode(unit) else {
            throw SCKeychainError.encodingFailed
        }

        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : key,
            kSecValueData as String   : data
        ]

        keychain.delete(query as CFDictionary)
        let status = keychain.add(query as CFDictionary)
        guard status == errSecSuccess else {
            throw SCKeychainError.saveFailed(status: status)
        }
    }

    public func load() throws -> SCKeychainStorableUnit? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : key,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = keychain.copyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess else { throw SCKeychainError.loadFailed }
        guard let data = dataTypeRef as? Data,
              let creds = try? JSONDecoder().decode(SCCredentials.self, from: data) else {
            throw SCKeychainError.decodeFailed
        }

        return creds
    }
}
