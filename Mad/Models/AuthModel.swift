//
//  AuthModel.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//


import Foundation
// MARK: - RegisterModel
struct RegisterModel: Codable {
    let success: Bool
    let data, message: String
    let errors: Errors?
}
