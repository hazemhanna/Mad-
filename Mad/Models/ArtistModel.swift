//
//  ArtistModel.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import Foundation
// MARK: - ProjectDetails
struct ArtistModelJson: Codable {
    let success: Bool?
    let data: ArtistModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ArtistModel: Codable {
    let countArtist, countPages: Int?
    let artists: [Artist]?

    enum CodingKeys: String, CodingKey {
        case countArtist = "count_artists"
        case countPages = "count_pages"
        case artists
    }
}

struct SuggestedModel: Codable {
    let success: Bool?
    let data: [Artist]?
    let message: String?
    let errors: Errors?
}

// MARK: - Datum
struct Artist: Codable {
    let id: Int?
    let name: String?
    let headline: String?
    let profilPicture: String?
    let bannerImg: String?
    let allFollowers, allFollowing: Int?
    let isFavorite, music, art, design: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, headline
        case profilPicture = "profil_picture"
        case bannerImg = "banner_img"
        case allFollowers = "all_followers"
        case allFollowing = "all_following"
        case isFavorite = "is_favorite"
        case music, art, design
    }
}
