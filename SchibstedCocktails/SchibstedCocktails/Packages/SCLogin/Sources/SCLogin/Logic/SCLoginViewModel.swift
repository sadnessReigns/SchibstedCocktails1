//
//  SCLoginViewModel.swift
//  SCLogin
//
//  Created by Uladzislau Makei on 24.05.25.
//

import Combine
import SCCommon
import SCNetworkingProtocols

@MainActor
public final class SCLoginViewModel: ObservableObject {

    @Published internal var username: String = "" {
        didSet {
            guard username != oldValue, errorText != nil else { return }
            
            errorText = nil
        }
    }
    @Published internal var password: String = "" {
        didSet {
            guard password != oldValue, errorText != nil else { return }

            errorText = nil
        }
    }

    @Published internal var isLoading = false
    @Published internal var errorText: String?

    private let networkingClient: SCNetworkClientProtocol
    private let keychainService: SCKeychainStorageServiceProtocol

    public var loginAttempt: ((Bool) -> Void)?

    public init(networkingClient: SCNetworkClientProtocol, keychainService: SCKeychainStorageServiceProtocol) {
        self.networkingClient = networkingClient
        self.keychainService = keychainService
    }

    @MainActor
    func login() async {
        errorText = nil
        isLoading = true

        // The API is too fast! :)
        try? await  Task.sleep(nanoseconds: 1_000_000_000)

        do {
            try self.keychainService.save(
                SCCredentials(
                    username: username,
                    password: password
                ),
                key: .userCredentials
            )
        } catch {
            isLoading = false
            print("Failed to save credentials: \(error)")
        }

        Task { [weak self] in
            guard let self else { return }

            do {
                _ = try await self.networkingClient.fetch(
                    .init(path: "/cocktails"),
                    as: [SCCocktail].self
                )
                isLoading = false
                self.loginAttempt?(true)
            } catch {
                isLoading = false
                self.loginAttempt?(false)
                self.errorText = switch error {
                case let SCNetworkError.network(SCNetworkError.serverError(code)):
                    switch code {
                    case 403: "Login or password is wrong."
                    default: "Network error. Please make sure you have access to internet."
                    }
                default:
                    "Unknown error. Please retry later."
                }
                print("Fetch error:", error)
            }
        }
    }
}
