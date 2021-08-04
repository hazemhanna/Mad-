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
    let history, ongoing: [History]?
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
