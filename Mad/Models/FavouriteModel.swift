//
//  FavouriteModel.swift
//  Mad
//
//  Created by MAC on 30/07/2021.
//

import Foundation

// MARK: - FavouriteModelJSON
struct FavouriteModelJSON: Codable {
    let success: Bool?
    let data: Favourites?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct Favourites: Codable {
    let favoriteArtists: [Artist]?
    let favoriteProducts: [Product]?
    let favoriteProjects: [Project]?
    let favoriteVideo: [Videos]?

    enum CodingKeys: String, CodingKey {
        case favoriteArtists = "favorite_artists"
        case favoriteProducts = "favorite_products"
        case favoriteProjects = "favorite_projects"
        case favoriteVideo = "favorite_video"
    }
}
