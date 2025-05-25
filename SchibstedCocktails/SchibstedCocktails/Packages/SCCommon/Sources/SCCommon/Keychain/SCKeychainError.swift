//
//  SCKeychainError.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Security

public enum SCKeychainError: Error, Equatable {
    case encodingFailed
    case saveFailed(status: OSStatus)
    case loadFailed
    case decodeFailed
}
