//
//  TimeSlot.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 24/07/24.
//

import Foundation

struct Api_TimeSlot : Codable {
    let result : [Res_TimeSlot]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_TimeSlot].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_TimeSlot : Codable {
    let id : String?
    let provider_id : String?
    let open_day : String?
    let open_time : String?
    let close_time : String?
    let open_close_status : String?
    let date_time : String?
    let time_slot : String?
    let time_slot_status : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case provider_id = "provider_id"
        case open_day = "open_day"
        case open_time = "open_time"
        case close_time = "close_time"
        case open_close_status = "open_close_status"
        case date_time = "date_time"
        case time_slot = "time_slot"
        case time_slot_status = "time_slot_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        provider_id = try values.decodeIfPresent(String.self, forKey: .provider_id)
        open_day = try values.decodeIfPresent(String.self, forKey: .open_day)
        open_time = try values.decodeIfPresent(String.self, forKey: .open_time)
        close_time = try values.decodeIfPresent(String.self, forKey: .close_time)
        open_close_status = try values.decodeIfPresent(String.self, forKey: .open_close_status)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        time_slot = try values.decodeIfPresent(String.self, forKey: .time_slot)
        time_slot_status = try values.decodeIfPresent(String.self, forKey: .time_slot_status)
    }

}
