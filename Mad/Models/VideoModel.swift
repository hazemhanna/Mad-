//
//  VideoModel.swift
//  Mad
//
//  Created by MAC on 13/05/2021.
//

import Foundation

struct VideoModelJson: Codable {
    let success: Bool?
    let data: VideoModel?
    let errors: Errors?

}
struct VideoModel: Codable {
    let Aftermovies: [Videos]?
    let Interviews: [Videos]?
    let Shows: [Videos]?
    let Showcases: [Videos]?

}

struct Videos: Codable {
    let id: Int?
    let title, imageURL, videoURL: String?
    let favoriteCount, shareCount: Int?
    let isFavorite: Bool?
    let createdAt: String?

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

struct VideoDetailsModelJson: Codable {
    let success: Bool?
    let data: VideoDetailsModel?
    let message: String?
    let errors: Errors?
}

struct VideoDetailsModel: Codable {
    let id: Int?
    let title: String?
    let imageURL: String?
    let videoURL: String?
    let favoriteCount, shareCount: Int?
    let isFavorite: Bool?
    let createdAt: String?
    let artists: [Artist]?
    let projects: [Project]?
    let products: [Product]?
    
    enum CodingKeys: String, CodingKey {
          case id, title
          case imageURL = "image_url"
          case videoURL = "video_url"
          case favoriteCount = "favorite_count"
          case shareCount = "share_count"
          case isFavorite = "is_favorite"
          case createdAt = "created_at"
          case artists, projects, products
      }
}



struct VideoFavouriteMdel: Codable {
    let success: Bool?
    let data: Videos?
    let message: String?
    let errors: Errors?

}
