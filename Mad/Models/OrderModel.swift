//
//  OrderModel.swift
//  Mad
//
//  Created by MAC on 04/08/2021.
//

import Foundation

// MARK: - OrderModelJSON
struct OrderModelJSON: Codable {
    let success: Bool?
    let data: OrderModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct OrderModel: Codable {
    let pending,history, ongoing: [History]?
}

// MARK: - History
struct History: Codable {
    let orderID, productID, productPrice, totalPrice: Int?
    let quantity: Int?
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case productID = "product_id"
        case productPrice = "product_price"
        case totalPrice = "total_price"
        case quantity, product
    }
}

// MARK: - OrderDetailsModelJSON
struct OrderDetailsModelJSON: Codable {
    let success: Bool?
    let data: OrderDetailsModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct OrderDetailsModel: Codable {
    let id, totalPrice: Int?
    let country, city, address, phone: String?
    let email, createdAt: String?
    let items: [Item]?

    enum CodingKeys: String, CodingKey {
        case id
        case totalPrice = "total_price"
        case country, city, address, phone, email
        case createdAt = "created_at"
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let orderID, productID, productPrice, totalPrice: Int
    let quantity: Int
    let product: Product

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case productID = "product_id"
        case productPrice = "product_price"
        case totalPrice = "total_price"
        case quantity, product
    }
}
