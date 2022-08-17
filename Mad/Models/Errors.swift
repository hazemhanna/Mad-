//
//  Errors.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation

// MARK: - Errors
struct Errors: Codable {
    var email: [String]?
    var comment: [String]?
    var price: [String]?

    enum CodingKeys: String, CodingKey {
        case email
        case comment
        case price

    }
}
