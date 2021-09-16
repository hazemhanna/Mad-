//
//  CategeoryModel.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation

// MARK: - Categeory
struct CategoryModel: Codable {
    let success: Bool?
    let data: [Category]?
    let message: String?
    let errors: Errors?

}

// MARK: - Datum
class Category: Codable {
    let id: Int?
    let imageURL: String?
    let name: String?
    var show = false

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name
    }
}
