//
//  SearchModel.swift
//  Mad
//
//  Created by MAC on 25/06/2021.
//

import Foundation

// MARK: - SearchModelJason
struct SearchModelJason: Codable {
    let success: Bool?
    let data: SearchModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct SearchModel: Codable {
    let popularArtists: [Artist]?
    let recentArtists: [Artist]?
    let recentProducts: [Product]?
    let recentProjects: [Project]?
    let recentTags: [Tags]?
    let recentCompetitions: [Competitions]?

    enum CodingKeys: String, CodingKey {
        case popularArtists = "popular_artists"
        case recentArtists = "recent_artists"
        case recentProducts = "recent_products"
        case recentProjects = "recent_projects"
        case recentTags = "recent_tags"
        case recentCompetitions = "recent_competitions"
    }
}


// MARK: - TagsModelJSON
struct TagsModelJSON: Codable {
    let success: Bool?
    let data: [Tags]?
    let message: String?
    let errors: Errors?
}

// MARK: - Datum
struct Tags: Codable {
    let id: Int?
    let imageURL, name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name
    }
}

// MARK: - Search

struct SearchArtistModel: Codable {
    let success: Bool?
    let data: [Artist]?
    let message: String?
    let errors: Errors?
}

struct SearchProductModel: Codable {
    let success: Bool?
    let data: [Product]?
    let message: String?
    let errors: Errors?
}

struct SearchProjectModel: Codable {
    let success: Bool?
    let data: [Project]?
    let message: String?
    let errors: Errors?
}

struct SearchCompetitionsModel: Codable {
    let success: Bool?
    let data: [Competitions]?
    let message: String?
    let errors: Errors?
}

struct SearchTagsModel: Codable {
    let success: Bool?
    let data: [Tags]?
    let message: String?
    let errors: Errors?
}
