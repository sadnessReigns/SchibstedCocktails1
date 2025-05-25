//
//  SCLoginCoordinator.swift
//  SchibstedCocktails
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit
import SCLogin
import SCNetworking
import SCNetworkingProtocols
import SCCommon

final class SCLoginCoordinator: SCCoordinator {
    private let navigationController: UINavigationController
    private let keychainService: SCKeychainStorageServiceProtocol
    private let networkingClient: SCNetworkClient
    
    var loginAttempt: ((Bool) -> Void)?

    init(
        navigationController: UINavigationController,
        keychainService: SCKeychainStorageServiceProtocol,
        networkingClient: SCNetworkClient
    ) {
        self.navigationController = navigationController
        self.keychainService = keychainService
        self.networkingClient = networkingClient
    }

    func start() {
        navigationController.isNavigationBarHidden = true
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let loginViewModel = SCLoginViewModel(
                networkingClient: self.networkingClient,
                keychainService: self.keychainService
            )

            loginViewModel.loginAttempt = loginAttempt

            let loginVC = SCLoginViewController(viewModel: loginViewModel)
            self.navigationController.setViewControllers([loginVC], animated: false)
        }
    }
}
