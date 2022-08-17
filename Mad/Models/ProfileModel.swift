//
//  ProfileModel.swift
//  Mad
//
//  Created by MAC on 09/08/2021.
//

import Foundation
// MARK: - ProfileModelJSON
struct ProfileModelJSON: Codable {
    let success: Bool?
    let data: ProfileModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct ProfileModel: Codable {
    let id: Int?
    let artistID: Int?
    let userID: Int?
    let name, firstName, lastName, userRegistered: String?
    let headline, about, level: String?
    let points: Int?
    let activatedArtist: Bool?
    let completed_profile: Bool?
    let userEmail, phone: String?
    let bannerImg: String?
    let profilPicture: String?
    let age: Int?
    let madArtist, activate: Bool?
    let country: String?
    let music, art, design: Bool?
    let facebook, instagram, twitter, youtube: String?
    let socialLinks: [Social]?
    let allFollowers, allFollowing: Int?
    let isFavorite, isOwner: Bool?
    let categories: [Category]?
    let videos : [Videos]?
    let products, pendingProducts, draftProducts : [Product]?
    let pendingProjects, draftProjects, projects: [Project]?
    let draftCompetitions, favoriteCompetitions,ongoingCompetitions, completedCompetitions: [Competitions]?
    enum CodingKeys: String, CodingKey {
        case id
        case artistID = "artist_id"
        case userID = "user_id"
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case userRegistered = "user_registered"
        case headline, about, level, points
        case activatedArtist = "activated_artist"
        case userEmail = "user_email"
        case phone
        case bannerImg = "banner_img"
        case profilPicture = "profil_picture"
        case age
        case madArtist = "mad_artist"
        case activate, country, music, art, design, facebook, instagram, twitter, youtube,videos,completed_profile
        case socialLinks = "social_links"
        case allFollowers = "all_followers"
        case allFollowing = "all_following"
        case isFavorite = "is_favorite"
        case isOwner = "is_owner"
        case categories, products
        case pendingProducts = "pending_products"
        case draftProducts = "draft_products"
        case projects
        case pendingProjects = "pending_projects"
        case draftProjects = "draft_projects"
        case ongoingCompetitions = "ongoing_competitions"
        case completedCompetitions = "completed_competitions"
        case draftCompetitions = "draft_competitions"
        case favoriteCompetitions = "favorite_competitions"
    }
}

