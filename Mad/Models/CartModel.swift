//
//  CartModel.swift
//  Mad
//
//  Created by MAC on 06/07/2021.
//

import Foundation

// MARK: - CartModelJSON
struct CartModelJSON: Codable {
    let success: Bool?
    let data: CartModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct CartModel : Codable {
    let totalPrice, totalQuantity: Int?
    let cardProducts: [Cart]?

    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case totalQuantity = "total_quantity"
        case cardProducts = "card_products"
    }
}

// MARK: - CardProduct
struct Cart: Codable {
    let productID, productPrice, totalPrice, quantity: Int?
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productPrice = "product_price"
        case totalPrice = "total_price"
        case quantity, product
    }
}


// MARK: - CartDetailsModelJSON
struct CartDetailsModelJSON: Codable {
    let success: Bool?
    let data: CartDetails?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct CartDetails: Codable {
    let country, city, address, phone: String?
    let email, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case country, city, address, phone, email
        case createdAt = "created_at"
    }
}
