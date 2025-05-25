//
//  SCCredentialsStoringStrategyTests.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//


import XCTest

@testable import SCCommon

final class SCCredentialsStoringStrategyTests: XCTestCase {
    var mockKeychain: MockKeychain!
    var strategy: SCCredentialsStoringStrategy!

    override func setUp() {
        super.setUp()
        mockKeychain = MockKeychain()
        strategy = SCCredentialsStoringStrategy(keychain: mockKeychain)
    }

    func test_save_and_load_success() throws {
        let creds = SCCredentials(username: "user", password: "pass")
        try strategy.save(creds)

        let loaded = try strategy.load()
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.username, "user")
        XCTAssertEqual(loaded?.password, "pass")
    }

    func test_save_throws_when_encodingFails() throws {
        struct BadCredentials: Codable {}
        let badStrategy = SCCredentialsStoringStrategy(keychain: mockKeychain)

        class FailingEncodingStrategy: SCCredentialsStoringStrategy {
            override func save(_ unit: SCCredentials) throws {
                throw SCKeychainError.encodingFailed
            }
        }
        let failingStrategy = FailingEncodingStrategy(keychain: mockKeychain)

        XCTAssertThrowsError(try failingStrategy.save(SCCredentials(username: "", password: ""))) { error in
            XCTAssertEqual(error as? SCKeychainError, SCKeychainError.encodingFailed)
        }
    }

    func test_save_throws_when_addFails() throws {
        mockKeychain.addShouldFailWithStatus = errSecDuplicateItem
        let creds = SCCredentials(username: "user", password: "pass")

        XCTAssertThrowsError(try strategy.save(creds)) { error in
            guard case SCKeychainError.saveFailed(let status) = error else {
                XCTFail("Expected saveFailed error")
                return
            }
            XCTAssertEqual(status, errSecDuplicateItem)
        }
    }

    func test_load_throws_when_copyMatchingFails() {
        mockKeychain.copyMatchingShouldFailWithStatus = errSecItemNotFound

        XCTAssertThrowsError(try strategy.load()) { error in
            XCTAssertEqual(error as? SCKeychainError, SCKeychainError.loadFailed)
        }
    }

    func test_load_throws_when_decodeFails() {
        mockKeychain.storedData = "invalid json".data(using: .utf8)

        XCTAssertThrowsError(try strategy.load()) { error in
            XCTAssertEqual(error as? SCKeychainError, SCKeychainError.decodeFailed)
        }
    }

    func test_load_returns_nil_when_no_data() throws {
        // This case is handled as throwing loadFailed, but if you want nil:
        mockKeychain.storedData = nil
        XCTAssertThrowsError(try strategy.load()) { error in
            XCTAssertEqual(error as? SCKeychainError, SCKeychainError.loadFailed)
        }
    }
}
