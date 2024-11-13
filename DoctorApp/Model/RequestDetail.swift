//
//  RequestDetail.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 22/07/24.
//

import Foundation

struct Api_RequestDetail : Codable {
    let result : Res_Request?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_Request.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_Request : Codable {
    let id : String?
    let user_id : String?
    let provider_id : String?
    let total_amount : String?
    let admin_commission : String?
    let provider_amount : String?
    let discount : String?
    let date : String?
    let time : String?
    let offer_id : String?
    let offer_code : String?
    let unique_code : String?
    let description : String?
    let time_slot : String?
    let payment_type : String?
    let payment_status : String?
    let status : String?
    let date_time : String?
    let timezone : String?
    let reason_title : String?
    let reason_detail : String?
    let payment_confirmation : String?
    let rating_review_status : String?
    let provider_details : Provider_details?
    let user_details : User_details?
    let request_images : [Request_images]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case provider_id = "provider_id"
        case total_amount = "total_amount"
        case admin_commission = "admin_commission"
        case provider_amount = "provider_amount"
        case discount = "discount"
        case date = "date"
        case time = "time"
        case offer_id = "offer_id"
        case offer_code = "offer_code"
        case unique_code = "unique_code"
        case description = "description"
        case time_slot = "time_slot"
        case payment_type = "payment_type"
        case payment_status = "payment_status"
        case status = "status"
        case date_time = "date_time"
        case timezone = "timezone"
        case reason_title = "reason_title"
        case reason_detail = "reason_detail"
        case payment_confirmation = "payment_confirmation"
        case rating_review_status = "rating_review_status"
        case provider_details = "provider_details"
        case user_details = "user_details"
        case request_images = "request_images"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        provider_id = try values.decodeIfPresent(String.self, forKey: .provider_id)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        admin_commission = try values.decodeIfPresent(String.self, forKey: .admin_commission)
        provider_amount = try values.decodeIfPresent(String.self, forKey: .provider_amount)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        offer_id = try values.decodeIfPresent(String.self, forKey: .offer_id)
        offer_code = try values.decodeIfPresent(String.self, forKey: .offer_code)
        unique_code = try values.decodeIfPresent(String.self, forKey: .unique_code)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        time_slot = try values.decodeIfPresent(String.self, forKey: .time_slot)
        payment_type = try values.decodeIfPresent(String.self, forKey: .payment_type)
        payment_status = try values.decodeIfPresent(String.self, forKey: .payment_status)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        reason_title = try values.decodeIfPresent(String.self, forKey: .reason_title)
        reason_detail = try values.decodeIfPresent(String.self, forKey: .reason_detail)
        payment_confirmation = try values.decodeIfPresent(String.self, forKey: .payment_confirmation)
        rating_review_status = try values.decodeIfPresent(String.self, forKey: .rating_review_status)
        provider_details = try values.decodeIfPresent(Provider_details.self, forKey: .provider_details)
        user_details = try values.decodeIfPresent(User_details.self, forKey: .user_details)
        request_images = try values.decodeIfPresent([Request_images].self, forKey: .request_images)
    }
}

struct Request_images : Codable {
    let id : String?
    let request_id : String?
    let image : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case request_id = "request_id"
        case image = "image"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }
}
