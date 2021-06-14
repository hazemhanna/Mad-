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
