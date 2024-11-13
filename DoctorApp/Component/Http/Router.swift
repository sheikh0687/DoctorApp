//
//  Router.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 18/07/24.
//

import Foundation

enum Router: String {
    
    static let BASE_Service_Url = "https://techimmense.in/crabconnect/webservice/"
    static let BASE_IMAGE_URL = "https://techimmense.in/crabconnect/uploads/images/"
    
    case login
    case signup
    case verify_number
    case forgot_password
    case change_password
    
    case get_country_list
    case get_proivder_book_appointment
    case get_profile
    case get_request_details
    case get_provider_details
    case get_provider_list
    case get_user_book_appointment_list
    case get_doctor_degree
    case get_time_slot
    case get_conversation_detail
    case get_chat_detail
    case get_rating_review
    case get_user_report
    
    case add_rating_review_by_order
    case add_doctor_degree
    case provider_update_profile
    case provider_add_time
    case add_book_appointment
    case add_user_report
    case insert_chat
    
    public func url() -> String {
        switch self {
        case .login:
            return Router.oAuthpath(oPath: "login")
        case .verify_number:
            return Router.oAuthpath(oPath: "verify_number")
        case .signup:
            return Router.oAuthpath(oPath: "signup")
        case .forgot_password:
            return Router.oAuthpath(oPath: "forgot_password")
        case .change_password:
            return Router.oAuthpath(oPath: "change_password")
            
        case .get_country_list:
            return Router.oAuthpath(oPath: "get_country_list")
        case .get_proivder_book_appointment:
            return Router.oAuthpath(oPath: "get_proivder_book_appointment")
        case .get_profile:
            return Router.oAuthpath(oPath: "get_profile")
        case .get_request_details:
            return Router.oAuthpath(oPath: "get_request_details")
        case .get_provider_details:
            return Router.oAuthpath(oPath: "get_provider_details")
        case .get_provider_list:
            return Router.oAuthpath(oPath: "get_provider_list")
        case .get_user_book_appointment_list:
            return Router.oAuthpath(oPath: "get_user_book_appointment_list")
        case .get_doctor_degree:
            return Router.oAuthpath(oPath: "get_doctor_degree")
        case .get_time_slot:
            return Router.oAuthpath(oPath: "get_time_slot")
        case .get_conversation_detail:
            return Router.oAuthpath(oPath: "get_conversation_detail")
        case .get_chat_detail:
            return Router.oAuthpath(oPath: "get_chat_detail")
        case .get_rating_review:
            return Router.oAuthpath(oPath: "get_rating_review")
        case .get_user_report:
            return Router.oAuthpath(oPath: "get_user_report")
            
        case .add_user_report:
            return Router.oAuthpath(oPath: "add_user_report")
        case .add_doctor_degree:
            return Router.oAuthpath(oPath: "add_doctor_degree")
        case .provider_update_profile:
            return Router.oAuthpath(oPath: "provider_update_profile")
        case .provider_add_time:
            return Router.oAuthpath(oPath: "provider_add_time")
        case .add_book_appointment:
            return Router.oAuthpath(oPath: "add_book_appointment")
        case .insert_chat:
            return Router.oAuthpath(oPath: "insert_chat")
      
        case .add_rating_review_by_order:
            return Router.oAuthpath(oPath: "add_rating_review_by_order")
        }
    }
    
    private static func oAuthpath(oPath: String) -> String {
        return Router.BASE_Service_Url + oPath
    }
}
