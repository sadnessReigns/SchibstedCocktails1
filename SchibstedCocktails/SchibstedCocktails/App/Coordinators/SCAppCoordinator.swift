//
//  SCAppCoordinator.swift
//  SchibstedCocktails
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit
import SCLogin
import SCNetworking
import SCCommon
import SCCocktailBar
import SCNetworkingProtocols

final class SCAppCoordinator: SCCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController

    private var childCoordinators = [SCCoordinator]()

    private let keychainService: SCKeychainStorageServiceProtocol
    private let networkingClient: SCNetworkClient

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always

        let baseURL = URL(string: "http://schibsted-nde-apps-recruitment-task.eu-central-1.elasticbeanstalk.com")!
        let cache = SCNetworkCache()
        self.networkingClient = SCNetworkClient(baseURL: baseURL, cache: cache)
        self.keychainService = SCKeychainStorageService()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showLogin()
    }
}

// MARK: - Sideways navigation

private extension SCAppCoordinator {

    func showLogin() {
        let loginCoordinator = SCLoginCoordinator(
            navigationController: navigationController,
            keychainService: keychainService,
            networkingClient: networkingClient
        )

        loginCoordinator.loginAttempt = { [weak self, weak loginCoordinator] isSuccess in
            if let index = self?.childCoordinators.firstIndex(where: { $0 === loginCoordinator }) {
                self?.childCoordinators.remove(at: index)
            }

            if isSuccess {
                DispatchQueue.main.async {
                    self?.showCocktailBar()
                }
            }
        }

        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }

    func showCocktailBar() {
        let cocktailBarCoordinator = SCCocktailBarCoordinator(
            navigationController: navigationController,
            networkingClient: networkingClient
        )

        childCoordinators.append(cocktailBarCoordinator)
        cocktailBarCoordinator.start()
    }
}
