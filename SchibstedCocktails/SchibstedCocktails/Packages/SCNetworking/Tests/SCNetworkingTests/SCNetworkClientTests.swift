import XCTest
import Foundation
import SCNetworkingProtocols

@testable import SCNetworking

final class SCNetworkClientTests: XCTestCase {

    struct DummyResponse: Codable, Sendable {
        let value: String
    }

    func makeClient(
        data: Data? = nil,
        response: URLResponse? = nil,
        error: Error? = nil,
        cachedData: Data? = nil,
        cacheShouldThrowOnGet: Bool = false,
        cacheShouldThrowOnStore: Bool = false
    ) async -> (SCNetworkClient, MockURLSession, MockCache) {
        let mockSession = MockURLSession(
            dataToReturn: data,
            responseToReturn: response,
            errorToThrow: error
        )

        let mockCache = MockCache()

        if let cachedData = cachedData {
            await mockCache.store(cachedData, for: NSURL(string: "https://example.com/test")!)
        }

        let client = SCNetworkClient(
            baseURL: URL(string: "https://example.com")!,
            session: mockSession,
            cache: mockCache
        )

        return (client, mockSession, mockCache)
    }

    func test_fetch_returnsDecodedObject_onSuccessfulResponse() async throws {
        let dummy = DummyResponse(value: "Hello")
        let data = try JSONEncoder().encode(dummy)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        let (client, _, _) = await makeClient(data: data, response: response)

        let result: DummyResponse = try await client.fetch(.init(path: "/test"), as: DummyResponse.self)

        XCTAssertEqual(result.value, "Hello")
    }

    func test_fetch_usesCachedData_whenAvailable() async throws {
        let dummy = DummyResponse(value: "Cached")
        let cachedData = try JSONEncoder().encode(dummy)

        let (client, _, _) = await makeClient(cachedData: cachedData)

        let result: DummyResponse = try await client.fetch(.init(path: "/test"), as: DummyResponse.self)

        XCTAssertEqual(result.value, "Cached")
    }

    func test_fetch_throwsNetworkError_onSessionError() async throws {
        enum TestError: Error { case some }

        let (client, _, _) = await makeClient(error: TestError.some)

        do {
            let _: DummyResponse = try await client.fetch(.init(path: "/test"), as: DummyResponse.self)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertTrue(error is SCNetworkError)
        }
    }

    func test_fetch_throwsServerError_onNon2xxResponse() async throws {
        let data = Data()
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!

        let (client, _, _) = await makeClient(data: data, response: response)

        do {
            let _: DummyResponse = try await client.fetch(.init(path: "/test"), as: DummyResponse.self)
            XCTFail("Expected to throw")
        } catch let SCNetworkError.network(inner) {
            guard case SCNetworkError.serverError(let code) = inner else {
                XCTFail("Expected SCNetworkError.serverError inside network, got \(inner)")
                return
            }
            XCTAssertEqual(code, 404)
        } catch {
            XCTFail("Expected SCNetworkError.network with serverError, got \(error)")
        }
    }

    func test_fetch_throwsDecodingError_onInvalidData() async throws {
        let data = Data("invalid json".utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        let (client, _, _) = await makeClient(data: data, response: response)

        do {
            let _: DummyResponse = try await client.fetch(.init(path: "/test"), as: DummyResponse.self)
            XCTFail("Expected to throw")
        } catch let SCNetworkError.network(inner) {
            guard case SCNetworkError.decodingError = inner else {
                XCTFail("Expected SCNetworkError.decodingError inside network, got \(inner)")
                return
            }
        } catch {
            XCTFail("Expected SCNetworkError.network with decodingError, got \(error)")
        }
    }
}
