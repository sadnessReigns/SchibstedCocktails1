//
//  SCCocktail.swift
//  SCNetworking
//
//  Created by Uladzislau Makei on 24.05.25.
//

public struct SCCocktail: Sendable, Codable {

    public enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrlString = "imageUrl"
    }

    public let id: String
    public let name: String
    public let imageUrlString: String
}
