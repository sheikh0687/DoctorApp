//
//  Booking.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 27/07/24.
//

import Foundation

struct Api_AddBooking : Codable {
    let result : Res_Booking?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_Booking.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_Booking : Codable {
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
    }

}
