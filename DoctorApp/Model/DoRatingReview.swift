//
//  DoRatingReview.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 12/11/24.
//

import Foundation

struct Api_DoRatingReview : Codable {
    let result : Res_DoRatingReview?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_DoRatingReview.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_DoRatingReview : Codable {
    let id : String?
    let request_id : String?
    let form_id : String?
    let to_id : String?
    let rating_recommend : String?
    let rating_punctual : String?
    let rating_treatment : String?
    let rating_language : String?
    let rating : String?
    let feedback : String?
    let type : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case request_id = "request_id"
        case form_id = "form_id"
        case to_id = "to_id"
        case rating_recommend = "rating_recommend"
        case rating_punctual = "rating_punctual"
        case rating_treatment = "rating_treatment"
        case rating_language = "rating_language"
        case rating = "rating"
        case feedback = "feedback"
        case type = "type"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        form_id = try values.decodeIfPresent(String.self, forKey: .form_id)
        to_id = try values.decodeIfPresent(String.self, forKey: .to_id)
        rating_recommend = try values.decodeIfPresent(String.self, forKey: .rating_recommend)
        rating_punctual = try values.decodeIfPresent(String.self, forKey: .rating_punctual)
        rating_treatment = try values.decodeIfPresent(String.self, forKey: .rating_treatment)
        rating_language = try values.decodeIfPresent(String.self, forKey: .rating_language)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        feedback = try values.decodeIfPresent(String.self, forKey: .feedback)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
