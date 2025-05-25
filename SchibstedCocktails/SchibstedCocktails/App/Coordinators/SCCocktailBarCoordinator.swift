//
//  SCCocktailBarCoordinator.swift
//  SchibstedCocktails
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit
import SCCommon
import SCNetworking
import SCCocktailBar

final class SCCocktailBarCoordinator: SCCoordinator {
    private let navigationController: UINavigationController
    private let networkingClient: SCNetworkClient

    init(
        navigationController: UINavigationController,
        networkingClient: SCNetworkClient
    ) {
        self.navigationController = navigationController
        self.networkingClient = networkingClient
    }

    func start() {
        navigationController.isNavigationBarHidden = false
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let viewModel = SCCocktailBarViewModel(networkClient: self.networkingClient)
            let mainVC = SCCocktailBarViewController(viewModel: viewModel)

            self.navigationController.setViewControllers([mainVC], animated: true)
        }
    }
}
