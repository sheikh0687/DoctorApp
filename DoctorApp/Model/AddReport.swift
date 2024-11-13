//
//  AddReport.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 12/11/24.
//

import Foundation

struct Api_AddReports : Codable {
    let result : Res_AddReports?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_AddReports.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_AddReports : Codable {
    let id : String?
    let user_id : String?
    let name : String?
    let report_file : String?
    let file_type : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case name = "name"
        case report_file = "report_file"
        case file_type = "file_type"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        report_file = try values.decodeIfPresent(String.self, forKey: .report_file)
        file_type = try values.decodeIfPresent(String.self, forKey: .file_type)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
