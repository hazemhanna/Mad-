//
//  Errors.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation
import Foundation

// MARK: - Errors
struct Errors: Codable {
    var email: [String]?
    var courseID: [String]?
    var comment: [String]?
    var price: [String]?
    var id_number: [String]?
    var medical_number: [String]?
    var phone : [String]?
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case email
        case comment
        case price
        case id_number
        case medical_number
        case phone

    }
}
