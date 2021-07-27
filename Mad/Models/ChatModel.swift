//
//  ChatModel.swift
//  Mad
//
//  Created by MAC on 27/07/2021.
//

import Foundation

// MARK: - CreatConversationModelJSON
struct CreatConversationModelJSON: Codable {
    let success: Bool?
    let data: CreatConversation?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct CreatConversation: Codable {
    let id: Int?
    let imageURL, title, subject, createdAt: String?
    let body: String?
    let object: Object?
    let expediteur, destinataire: Artist?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case title, subject
        case createdAt = "created_at"
        case body, object, expediteur, destinataire
    }
}



// MARK: - Object
struct Object: Codable {
    let id: Int?
    let artist: Artist?
    let title: String?
    let imageURL: String?
    let favoriteCount, shareCount: Int?
    let createdAt: String?
    let isFavorite: Bool?
    let price: Double?
    let priceEur: Int?

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


// MARK: - ConversationModelJSON
struct ConversationModelJSON: Codable {
    let success: Bool?
    let data: AllConversationModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct AllConversationModel: Codable {
    let inbox, unread, sent: [Inbox]
}

// MARK: - Inbox
struct Inbox: Codable {
    let id: Int?
    let imageURL, title: String?
    let subject: String?
    let createdAt: String?
    let body: String?
    let object: Object?
    let expediteur, destinataire: Artist?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case title, subject
        case createdAt = "created_at"
        case body, object, expediteur, destinataire
    }
}



// MARK: - MessagesModelJSON
struct MessagesModelJSON: Codable {
    let success: Bool?
    let data: [Messages]?
    let message: String?
    let errors: Errors?
}

// MARK: - Datum
struct Messages: Codable {
    let id: Int?
    let user: Artist?
    let destinataire: Artist?
    let content: String?
    let attachement: String?
    let date: String?
    let seen: Int?
}
