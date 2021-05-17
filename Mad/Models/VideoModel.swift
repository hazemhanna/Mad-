//
//  VideoModel.swift
//  Mad
//
//  Created by MAC on 13/05/2021.
//

import Foundation

struct VideoModelJson: Codable {
    let success: Bool
    let data: [VideoModel]
}
struct VideoModel: Codable {
    let Aftermovies: [Videos]?
    let Interviews: Videos?
    let Shows: [Videos]?
    let Showcases: [Videos]?

}

// MARK: - Item
struct Videos: Codable {
    let id: Int
    let title, imageURL, videoURL: String
    let favoriteCount, shareCount: Int
    let isFavorite: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case imageURL = "image_url"
        case videoURL = "video_url"
        case favoriteCount = "favorite_count"
        case shareCount = "share_count"
        case isFavorite = "is_favorite"
        case createdAt = "created_at"
    }
}
