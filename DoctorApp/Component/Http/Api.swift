//
//  Api.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 18/07/24.
//

import Foundation

class Api: NSObject {
    
    static let shared = Api()
    
    func paramGetUserId() -> [String : AnyObject]
    {
        var dict: [String : AnyObject] = [:]
        dict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject
        return dict
    }
    
    func login(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData: Res_NetworkRechability) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.login.url(), params: param, method: .get, vc: vc, successBlock: {
            (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_NetworkReachability.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.hideProgressBar()
                    k.userDefault.set(false, forKey: k.session.status)
                    k.userDefault.set(k.emptyString, forKey: k.session.userId)
                    k.userDefault.set(k.emptyString, forKey: k.session.userEmail)
                    k.userDefault.set(k.emptyString, forKey: k.session.type)
                    k.userDefault.set(k.emptyString, forKey: k.session.userName)
                    vc.alert(alertmessage: root.message ?? "")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func signup(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData: Res_NetworkRechability) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.signup.url(), params: param, method: .get, vc: vc, successBlock: {
            (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_NetworkReachability.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.hideProgressBar()
                    k.userDefault.set(false, forKey: k.session.status)
                    k.userDefault.set(k.emptyString, forKey: k.session.userId)
                    k.userDefault.set(k.emptyString, forKey: k.session.userEmail)
                    k.userDefault.set(k.emptyString, forKey: k.session.type)
                    k.userDefault.set(k.emptyString, forKey: k.session.userName)
                    vc.alert(alertmessage: root.message ?? "")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func verify_MobileNumber(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : Res_VerifyNumber) -> Void) {
        vc.blockUi()
        Service.post(url: Router.verify_number.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_VerifyNum.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "Something Went Wrong!")
                }
                vc.unBlockUi()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.unBlockUi()
        }
    }
    
    func forgot_Password(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : Api_Basic) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.forgot_password.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_Basic.self, from: response)
                if root.result != nil {
                    success(root)
                }
            } catch {
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func update_Password(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : Api_Basic) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.change_password.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_Basic.self, from: response)
                if root.result != nil {
                    success(root)
                }
            } catch {
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func countryList(_ vc: UIViewController,_ success: @escaping(_ responseData: [Res_CountryList]) -> Void) {
        Service.post(url: Router.get_country_list.url(), params: paramGetUserId(), method: .get, vc: vc) { responseData in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_CountryList.self, from: responseData)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "")
                }
            } catch {
                print(error)
            }
        } failureBlock: { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
        }
    }
    
    func book_Appoinment(_ vc: UIViewController,_ paramDict: [String : AnyObject],_ success: @escaping(_ responseData: Api_BookAppointment) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_proivder_book_appointment.url(), params: paramDict, method: .get, vc: vc) { responseData in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_BookAppointment.self, from: responseData)
                if root.result != nil {
                    success(root)
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        } failureBlock: { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func profile(_ vc: UIViewController,_ success: @escaping(_ responseData: Res_NetworkRechability) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_profile.url(), params: paramGetUserId(), method: .get, vc: vc) { responseData in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_NetworkReachability.self, from: responseData)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                        vc.hideProgressBar()
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "")
                    vc.hideProgressBar()
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        } failureBlock: { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func upload_DoctorDegree(_ vc: UIViewController, _ params: [String: String], images: [String : Data?]?, videos: [String : Data?]?, _ success: @escaping(_ responseData : Res_AddDegree) -> Void) {
        vc.showProgressBar()
        Service.postWithData(url: Router.add_doctor_degree.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock: { (responseData) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_AddDegree.self, from: responseData)
                if root.status == "1" {
                    vc.hideProgressBar()
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.hideProgressBar()
                    vc.alert(alertmessage: root.message ?? "Something went wrong")
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func update_ProviderProfile(_ vc: UIViewController, _ params: [String: String], images: [String : UIImage?]?, videos: [String : Data?]?, _ success: @escaping(_ responseData : Res_NetworkRechability) -> Void) {
        vc.showProgressBar()
        Service.postSingleMedia(url: Router.provider_update_profile.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock: { (responseData) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_NetworkReachability.self, from: responseData)
                if root.status == "1" {
                    vc.hideProgressBar()
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.hideProgressBar()
                    vc.alert(alertmessage: root.message ?? "Something went wrong")
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func request_Detail(_ vc: UIViewController,_ paramDict: [String : AnyObject],_ success: @escaping(_ responseData: Res_Request) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_request_details.url(), params: paramDict, method: .get, vc: vc) { responseData in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_RequestDetail.self, from: responseData)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        } failureBlock: { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func provider_Info(_ vc: UIViewController,_ paramDict: [String : AnyObject],_ success: @escaping(_ responseData: Res_ProviderDetails) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_provider_details.url(), params: paramDict, method: .get, vc: vc) { responseData in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_ProviderDetails.self, from: responseData)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        } failureBlock: { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func provider_AddTime(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : Api_Basic) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.provider_add_time.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_Basic.self, from: response)
                if root.result != nil {
                    success(root)
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func provider_List(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : [Res_ProviderList]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_provider_list.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_ProviderList.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }  else {
                    vc.alert(alertmessage: root.message ?? "")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func user_BookingAppointment(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : Api_UserBookAppointment) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_user_book_appointment_list.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_UserBookAppointment.self, from: response)
                if root.result != nil {
                    success(root)
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func doctor_DegreeList(_ vc: UIViewController,_ success: @escaping(_ responseData : [Res_DegreeList]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_doctor_degree.url(), params: paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_DegreeList.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }  else {
                    print("No Data Found")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func last_Conversation(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : [Res_LastChat]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_conversation_detail.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_LastChat.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }  else {
                    print("No Data Found")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func conversation_Detail(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : [Res_ChatDetails]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_chat_detail.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_ChatDetails.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }  else {
                    print("No Data Found")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func sendChat(_ vc: UIViewController, _ params: [String: String], images: [String : UIImage?]?,videos: [String : Data?]?, _ success: @escaping(_ responseData : ResSendChat) -> Void) {
        vc.showProgressBar()
        Service.postSingleMedia(url: Router.insert_chat.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock:  { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiSendChat.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "Something went wrong")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func time_Slot(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : [Res_TimeSlot]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_time_slot.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_TimeSlot.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }  else {
                    print("No Data Found")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func add_Booking(_ vc: UIViewController,_ param: [String : String],_ paramImage: [String : Array<Any>],_ success: @escaping(_ responseData : Res_Booking) -> Void) {
        vc.showProgressBar()
        Service.postWithMedia(url: Router.add_book_appointment.url(), params: param, imageParam: paramImage, videoParam: [:], vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_AddBooking.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }  else {
                    print("No Data Found")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToRatingReview(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : [Res_RatingReview]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_rating_review.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_RatingReview.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                        vc.hideProgressBar()
                    }
                }  else {
                    print("No Data Found")
                    vc.hideProgressBar()
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToAddRating(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : Res_DoRatingReview) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.add_rating_review_by_order.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_DoRatingReview.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                        vc.hideProgressBar()
                    }
                }  else {
                    print("No Data Found")
                    vc.hideProgressBar()
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToUserReports(_ vc: UIViewController,_ param: [String : AnyObject],_ success: @escaping(_ responseData : [Res_UserReports]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_user_report.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_Reports.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                        vc.hideProgressBar()
                    }
                }  else {
                    print("No Data Found")
                    vc.hideProgressBar()
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToUploadUserReport(_ vc: UIViewController, _ params: [String: String], images: [String : Data?]?, videos: [String : Data?]?, _ success: @escaping(_ responseData : Res_AddReports) -> Void) {
        vc.showProgressBar()
        Service.postWithData(url: Router.add_user_report.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock: { (responseData) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_AddReports.self, from: responseData)
                if root.status == "1" {
                    vc.hideProgressBar()
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.hideProgressBar()
                    vc.alert(alertmessage: root.message ?? "Something went wrong")
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
}
