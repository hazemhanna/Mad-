//
//  CompetitionModel.swift
//  Mad
//
//  Created by MAC on 10/06/2021.
//

import Foundation

// MARK: - CompetitionsModelJSON
struct CompetitionsModelJSON: Codable {
    let success: Bool?
    let data: CompetitionsModel?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct CompetitionsModel: Codable {
    let countItems, countPages: Int?
    let data: [Competitions]?

    enum CodingKeys: String, CodingKey {
        case countItems = "count_items"
        case countPages = "count_pages"
        case data
    }
}

// MARK: - Datum
struct Competitions: Codable {
    let id: Int?
    let title, bannerImg, step1Start, step1End: String?
    let step2Start, step2End, resultDate: String?
    let candidate: Candidate?

    enum CodingKeys: String, CodingKey {
        case id, title
        case bannerImg = "banner_img"
        case step1Start = "step1_start"
        case step1End = "step1_end"
        case step2Start = "step2_start"
        case step2End = "step2_end"
        case resultDate = "result_date"
        case candidate
    }
}

// MARK: - Candidate
struct Candidate: Codable {
    let id: Int?
    let isArtist: Bool?
    let name: String?
    let imageURL, bannerImg: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    let selectedForStep2, isVoted: Bool?
    let publishedStatus: String?
    let artistName: String?
    let town: String?
    let birthday: String?
    let email: String?
    let introduction: String?
    let introductionFile: String?
    let videoLink: String?
    let projectDescription: String?
    let projectDescriptionFile: String?
    let knowAbout: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isArtist = "is_artist"
        case name
        case imageURL = "image_url"
        case bannerImg = "banner_img"
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case selectedForStep2 = "selected_for_step2"
        case isVoted = "is_voted"
        case publishedStatus = "published_status"
        case artistName = "artist_name"
        case town, birthday, email, introduction
        case introductionFile = "introduction_file"
        case videoLink = "video_link"
        case projectDescription = "project_description"
        case projectDescriptionFile = "project_description_file"
        case knowAbout = "know_about"
    }
}

// MARK: - CompetitionsDetailsModelJSON
struct CompetitionsDetailsModelJSON: Codable {
    let success: Bool?
    let data: CompetitionsDetails?
    let message: String?
    let errors: Errors?
}

// MARK: - DataClass
struct CompetitionsDetails: Codable {
    let id: Int?
    let title, about, guidelines, deadlines: String?
    let prizes: String?
    let judges: [Judge]?
    let partner, bannerImg, step1Start, step1End: String?
    let step2Start, step2End, resultDate, step1Message: String?
    let step2Message, status: String?
    let countAllVotes: Int?
    let winner: Winner?
    let finalists, shortlisted: [Winner]?
    let candidate : [Winner]?
    let can_compete ,can_vote,end_competition :Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, about, guidelines, deadlines, prizes, judges, partner
        case bannerImg = "banner_img"
        case step1Start = "step1_start"
        case step1End = "step1_end"
        case step2Start = "step2_start"
        case step2End = "step2_end"
        case resultDate = "result_date"
        case step1Message = "step1_message"
        case step2Message = "step2_message"
        case status
        case countAllVotes = "count_all_votes"
        case winner, finalists, shortlisted,candidate
        case can_compete, can_vote,end_competition
    }
}

// MARK: - Winner
struct Winner: Codable {
    let id: Int?
    let isArtist: Bool?
    let name: String?
    let imageURL: String?
    let firstName, lastName: String?
    let selectedForStep2, isVoted: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case isArtist = "is_artist"
        case name
        case imageURL = "image_url"
        case firstName = "first_name"
        case lastName = "last_name"
        case selectedForStep2 = "selected_for_step2"
        case isVoted = "is_voted"
    }
}

// MARK: - Judge
struct Judge: Codable {
    let id: Int?
    let name, headline: String?
    let profilPicture: String?
    let bannerImg: String?
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


struct AboutCompetitionsModelJSON: Codable {
    let success: Bool?
    let data: [SocialModel]?
    let message: String?
    let errors: Errors?
}

struct SocialModel: Codable {
    let key, value : String?
}
