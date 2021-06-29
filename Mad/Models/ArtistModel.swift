//
//  ArtistModel.swift
//  Mad
//
//  Created by MAC on 21/04/2021.
//

import Foundation

// MARK: - ArtistsMainModel
struct ArtistsMainModel: Codable {
    let success: Bool?
    let data: ArtistModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ArtistModel: Codable {
    let countItems, countPages: Int?
    let data: [Artist]?

    enum CodingKeys: String, CodingKey {
        case countItems = "count_items"
        case countPages = "count_pages"
        case data
    }
}

// MARK: - Datum
struct Artist: Codable {
    let id: Int?
    let name, headline: String?
    let profilPicture, bannerImg: String?
    let allFollowers, allFollowing: Int?
    let isFavorite, music, art, design: Bool?
    let isMadProfile: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, headline
        case profilPicture = "profil_picture"
        case bannerImg = "banner_img"
        case allFollowers = "all_followers"
        case allFollowing = "all_following"
        case isFavorite = "is_favorite"
        case music, art, design
        case isMadProfile = "is_mad_profile"
    }
}

struct SuggestedModel: Codable {
    let success: Bool?
    let data: [Artist]?
    let message: String?
    let errors: Errors?
}

struct ArtistFavouriteModel: Codable {
    let success: Bool?
    let data: Artist?
    let message: String?
    let errors: Errors?
}


// MARK: - ArtistProfileModelJSON
struct ArtistProfileModelJSON: Codable {
    let success: Bool?
    let data: ArtistProfileModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ArtistProfileModel: Codable {
    let id: Int?
    let name, firstName, lastName, userRegistered: String?
    let headline, about, level: String?
    let points: Int?
    let userEmail, phone: String?
    let bannerImg, profilPicture: String?
    let age: Int?
    let madArtist, activate: Bool?
    let country: String?
    let music, art, design: Bool?
    let facebook, instagram, twitter, youtube: String?
    let allFollowers, allFollowing: Int?
    let isFavorite, isOwner: Bool?
    let projects: [Project]?
    let products: [Product]?
    let socialLinks : [Social]?
    let ongoingCompetitions: [OngoingCompetition]?
    let completedCompetitions: [OngoingCompetition]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstName = "first_name"
        case lastName = "last_name"
        case userRegistered = "user_registered"
        case headline, about, level, points
        case userEmail = "user_email"
        case phone
        case bannerImg = "banner_img"
        case profilPicture = "profil_picture"
        case age
        case madArtist = "mad_artist"
        case activate, country, music, art, design, facebook, instagram, twitter, youtube
        case allFollowers = "all_followers"
        case allFollowing = "all_following"
        case isFavorite = "is_favorite"
        case isOwner = "is_owner"
        case projects, products
        case ongoingCompetitions = "ongoing_competitions"
        case completedCompetitions = "completed_competitions"
        case  socialLinks  = "social_links"
    }
}

struct Social: Codable {
    let name, url, icon: String?
}

// MARK: - OngoingCompetition
struct OngoingCompetition: Codable {
    let id: Int?
    let title, bannerImg, step1Start, step1End: String?
    let step2Start, step2End, resultDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case bannerImg = "banner_img"
        case step1Start = "step1_start"
        case step1End = "step1_end"
        case step2Start = "step2_start"
        case step2End = "step2_end"
        case resultDate = "result_date"
    }
}

