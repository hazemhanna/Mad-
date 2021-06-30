//
//  ProductModel.swift
//  Mad
//
//  Created by MAC on 27/04/2021.
//

import Foundation

struct ProductModelJson: Codable {
    let success: Bool?
    let data: ProductModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ProductModel: Codable {
    let countitems, countPages: Int
    let data: [Product]?

    enum CodingKeys: String, CodingKey {
        case countitems = "count_items"
        case countPages = "count_pages"
        case data
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let artist: Artist?
    let title: String?
    let imageURL: String?
    let favoriteCount, shareCount: Int?
    let createdAt: String?
    let isFavorite: Bool?
    let price, priceEur: Double?

    enum CodingKeys: String, CodingKey {
        case id, artist, title
        case imageURL = "image_url"
        case favoriteCount = "favorite_count"
        case shareCount = "share_count"
        case createdAt = "created_at"
        case isFavorite = "is_favorite"
        case price
        case priceEur = "price_eur"
    }
}


// MARK: - SugessteProductModel
struct SugessteProduct: Codable {
    let success: Bool?
    let data: [Product]?
    let message: String?
    let errors: Errors?
}



struct ProductDetailsModelJson: Codable {
    let success: Bool?
    let data: ProductDetailsModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ProductDetailsModel: Codable {
    
    let id: Int
    let artist: Artist?
    let title: String?
    let imageURL: String?
    let favoriteCount, shareCount: Int?
    let createdAt: String?
    let isFavorite: Bool?
    let price, priceEur, delivery : Int?
    let type, shortDescription, dataDescription, materials,deliveryIndex: String?
    let length, width, height, weight: Int?
    let photos: [String]?
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case id, artist, title
        case imageURL = "image_url"
        case favoriteCount = "favorite_count"
        case shareCount = "share_count"
        case createdAt = "created_at"
        case isFavorite = "is_favorite"
        case price
        case priceEur = "price_eur"
        case delivery
        case deliveryIndex = "delivery_index"
        case type
        case shortDescription = "short_description"
        case dataDescription = "description"
        case materials, length, width, height, weight, photos, categories
    }
}

struct ProductFavouriteModel: Codable {
    let success: Bool?
    let data: ProductFavourite?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ProductFavourite: Codable {
    let id: Int?
    let artist: Artist?
    let name: String?
    let imageURL: String?
    let favoriteCount, shareCount: Int?
    let createdAt: String?
    let isFavorite: Bool?
    let price, priceEur: Int?

    enum CodingKeys: String, CodingKey {
        case id, artist, name
        case imageURL = "image_url"
        case favoriteCount = "favorite_count"
        case shareCount = "share_count"
        case createdAt = "created_at"
        case isFavorite = "is_favorite"
        case price
        case priceEur = "price_eur"
    }
}

struct AddProductModelJson: Codable {
    let success: Bool?
    let data: String?
    let message: String?
    let errors: Errors?
}


struct ArtistProductModel: Codable {
    let success: Bool?
    let data: [Product]?
    let message: String?
    let errors: Errors?
}
