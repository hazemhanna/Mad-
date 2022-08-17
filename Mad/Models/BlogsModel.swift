//
//  BlogsModel.swift
//  Mad
//
//  Created by MAC on 14/07/2021.
//


import Foundation

// MARK: - BlogModelJSON
struct BlogModelJSON: Codable {
    let success: Bool?
    let data: BlogModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct BlogModel: Codable {
    let countItems, countPages: Int?
    let data: [Blog]?

    enum CodingKeys: String, CodingKey {
        case countItems = "count_items"
        case countPages = "count_pages"
        case data
    }
}

// MARK: - Datum
struct Blog: Codable {
    let id: Int?
    let title: String?
    let type: String?
    let status: String?
    let imageURL: String?
    let shareCount: Int?
    let createdAt, content: String?
    let relateProducts: [Product]?

    enum CodingKeys: String, CodingKey {
        case id, title, type, status
        case imageURL = "image_url"
        case shareCount = "share_count"
        case createdAt = "created_at"
        case content
        case relateProducts = "relate_products"
    }
}


struct BlogDetailsModelJSON: Codable {
    let success: Bool?
    let data: BlogDetailsModel?
    let message: String?
    let errors: Errors?
}

struct BlogDetailsModel: Codable {
    let id: Int?
    let title, type, status: String?
    let imageURL: String?
    let shareCount: Int?
    let createdAt: String?
    let music, art, design: Bool?
    let categories: [Category]?
    let content: String?
    let relateProducts: [Product]?
    let relate_artists : [Artist]?
    let relate_projects : [Project]?

    enum CodingKeys: String, CodingKey {
        case id, title, type, status
        case imageURL = "image_url"
        case shareCount = "share_count"
        case createdAt = "created_at"
        case music, art, design, categories, content
        case relateProducts = "relate_products"
        case relate_artists = "relate_artists"
        case relate_projects = "relate_projects"

    }
}
