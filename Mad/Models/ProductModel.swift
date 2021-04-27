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
    let countProducts, countPages: Int
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case countProducts = "count_products"
        case countPages = "count_pages"
        case products
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

