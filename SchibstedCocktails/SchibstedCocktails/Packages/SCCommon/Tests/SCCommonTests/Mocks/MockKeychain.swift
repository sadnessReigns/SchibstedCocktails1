//
//  MockKeychain.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//


import Foundation
import SCCommon

final class MockKeychain: SCKeychainProtocol {
    var storedData: Data?
    var addShouldFailWithStatus: OSStatus?
    var copyMatchingShouldFailWithStatus: OSStatus?
    var deleteShouldFailWithStatus: OSStatus?

    func add(_ query: CFDictionary) -> OSStatus {
        if let fail = addShouldFailWithStatus { return fail }

        if let dict = query as? [String: Any],
           let data = dict[kSecValueData as String] as? Data {
            storedData = data
        }
        return errSecSuccess
    }

    func delete(_ query: CFDictionary) -> OSStatus {
        if let fail = deleteShouldFailWithStatus { return fail }
        storedData = nil
        return errSecSuccess
    }

    func copyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<AnyObject?>) -> OSStatus {
        if let fail = copyMatchingShouldFailWithStatus { return fail }
        if let data = storedData {
            result.pointee = data as AnyObject
            return errSecSuccess
        }
        return errSecItemNotFound
    }
}
