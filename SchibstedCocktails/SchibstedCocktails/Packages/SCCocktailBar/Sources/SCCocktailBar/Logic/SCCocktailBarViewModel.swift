//
//  SCCocktailBarViewModel.swift
//  SCCocktailBar
//
//  Created by Uladzislau Makei on 24.05.25.
//

import SCCommon
import SCNetworkingProtocols
import Foundation
import Combine

@MainActor
public final class SCCocktailBarViewModel {

    // MARK: - Data

    private let networkClient: SCNetworkClientProtocol
    @Published private(set) var cocktails: [SCCocktailItem] = []

    // MARK: - State comms

    var cocktailsComms = CurrentValueSubject<[SCCocktailItem], Never>([])

    // MARK: - Init

    public init(networkClient: SCNetworkClientProtocol) {
        self.networkClient = networkClient
    }
}

// MARK: - Loading

extension SCCocktailBarViewModel {

    @MainActor
    func loadCocktails() async {

        do {
            let result = try await networkClient.fetch(
                .init(path: "/cocktails"),
                as: [SCCocktail].self
            )

            cocktails = result.compactMap { item -> SCCocktailItem? in
                guard let imageURL = URL(string: item.imageUrlString) else { return nil }

                return SCCocktailItem(id: item.id, title: item.name, imageURL: imageURL)
            }
        } catch {
            print("Fetch error:", error)
        }
    }
}
