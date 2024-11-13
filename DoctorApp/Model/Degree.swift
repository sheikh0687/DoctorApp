//
//  Degree.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 22/07/24.
//

import Foundation

struct Api_AddDegree : Codable {
    let result : Res_AddDegree?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_AddDegree.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_AddDegree : Codable {
    let id : String?
    let user_id : String?
    let name : String?
    let degree_file : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case name = "name"
        case degree_file = "degree_file"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        degree_file = try values.decodeIfPresent(String.self, forKey: .degree_file)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
