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


// MARK: - ProjectDetails
struct ProjectDetailsModel: Codable {
    let success: Bool?
    let data: ProjectDetails?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ProjectDetails: Codable {
    let id: Int?
    let artist: Artist?
    let title, name, type, status: String?
    let imageURL: String?
    let favoriteCount, shareCount: Int?
    let createdAt: String?
    let isFavorite: Bool?
    let categories: [Category]?
    let comments: [Comments]?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case id, artist, title, name, type, status
        case imageURL = "image_url"
        case favoriteCount = "favorite_count"
        case shareCount = "share_count"
        case createdAt = "created_at"
        case isFavorite = "is_favorite"
        case categories, comments, content
    }
}


// MARK: - Comments
struct Comments: Codable {
    let id: Int?
    let title, content, createdAt: String?
    let author: Author?

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case createdAt = "created_at"
        case author
    }
}

// MARK: - Author
struct Author: Codable {
    let id: Int?
    let firstName, lastName: String?
    let madArtist, activate: Bool?
    let userEmail, userRegistered: String?
    let profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case madArtist = "mad_artist"
        case activate
        case userEmail = "user_email"
        case userRegistered = "user_registered"
        case profilePicture = "profile_picture"
    }
}

struct FavouriteModel: Codable {
    let success: Bool?
    let data: Favourite?
    let message: String?
    let errors: Errors?
}

struct Favourite: Codable {
    let id: Int?
    let postTitle, postName, postType, postStatus: String?
    let imageURL: String?
    let favoriteCount: Int?
    let isFavorite: Bool?
    let content: String?
    let categories: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postTitle = "post_title"
        case postName = "post_name"
        case postType = "post_type"
        case postStatus = "post_status"
        case imageURL = "image_url"
        case favoriteCount = "favorite_count"
        case isFavorite = "is_favorite"
        case content, categories
    }
}



struct ShareModel: Codable {
    let success: Bool?
    let data: Int?
    let message: String?
    let errors: Errors?
}

