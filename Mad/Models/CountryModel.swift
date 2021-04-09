//
//  CountryModel.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//

import Foundation


// MARK: - CountryModel
struct CountryModel: Codable {
    let success: Bool?
    let data: [Country]?
    let message: String?
    let errors: Bool?
}

// MARK: - Datum
struct Country: Codable {
    let id: Int?
    let name: String?
}
