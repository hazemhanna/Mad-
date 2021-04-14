//
//  ProjectsModel.swift
//  Mad
//
//  Created by MAC on 14/04/2021.
//

import Foundation


// MARK: - ProjectModel
struct ProjectMainModel: Codable {
    let success: Bool?
    let data: ProjectModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ProjectModel: Codable {
    let countProjects, countPages: Int?
    let projects: [Project]?

    enum CodingKeys: String, CodingKey {
        case countProjects = "count_projects"
        case countPages = "count_pages"
        case projects
    }
}

// MARK: - Project
struct Project: Codable {
    let id: Int?
    let artist: Artist?
    let title: String?
    let imageURL: String?
    let favoriteCount, shareCount: Int?
    let createdAt: String?
    let isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case id, artist, title
        case imageURL = "image_url"
        case favoriteCount = "favorite_count"
        case shareCount = "share_count"
        case createdAt = "created_at"
        case isFavorite = "is_favorite"
    }
}

// MARK: - Artist
struct Artist: Codable {
    let id: Int
    let name: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
    }
}
