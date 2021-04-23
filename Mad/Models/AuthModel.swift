//
//  AuthModel.swift
//  Mad
//
//  Created by MAC on 09/04/2021.
//


import Foundation

struct AuthModel: Codable {
    let success: Bool?
    let data, message: String?
    let errors: Errors?
}

struct VerifyModel: Codable {
    let success , data: Bool?
    let  message: String?
    let errors: Errors?
}

struct AuthRegisterModel: Codable {
    let success: Bool?
    let data: RegisterModel?
    let message: String?
    let errors: Errors?
}

struct RegisterModel: Codable {
    let user: User?
    let accessToken, tokenType: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let firstName, lastName: String?
    let age: Int?
    let madArtist, activate: Bool?
    let userEmail, userRegistered: String?
    let country: Country?
    let categories: [Category]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case age
        case madArtist = "mad_artist"
        case activate
        case userEmail = "user_email"
        case userRegistered = "user_registered"
        case country, categories
    }
}


