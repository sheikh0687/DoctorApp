//
//  PatientInfoVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit

class PatientInfoVC: UIViewController {
    
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    
    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var btn_SeeReportOt: UIButton!
    @IBOutlet weak var btn_RequestStatusOt: UIButton!
    
    var request_Id:String = ""
    var type:String = ""
    
    var userName:String = ""
    var receiverId:String = ""
    var user_ID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDetail()
        if type == "USER" {
            self.lbl_Heading.text = "Appointment Details"
            self.btn_SeeReportOt.isHidden = true
            self.btn_RequestStatusOt.isHidden = true
//            self.btn_RequestStatusOt.setTitle("Cancel Request", for: .normal)
        } else {
            self.lbl_Heading.text = "Patient Info"
            self.btn_SeeReportOt.isHidden = false
            self.btn_RequestStatusOt.isHidden = false
            self.btn_RequestStatusOt.setTitle("Accept", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func btn_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_PatientReport(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
        vc.user_Id = self.user_ID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Accept(_ sender: UIButton) {
        
    }
    
    @IBAction func btn_Chat(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ConversationVC") as! ConversationVC
        vc.userName = self.userName
        vc.request_Id = self.request_Id
        vc.receiver_Id = self.receiverId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PatientInfoVC {
    
    func requestDetail()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["provider_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject
        paramDict["request_id"] = request_Id as AnyObject
        
        print(paramDict)
        
        Api.shared.request_Detail(self, paramDict) { responseData in
            let obj = responseData
            if self.type != "USER" {
                self.lbl_Name.text = "\(obj.user_details?.first_name ?? "") \(obj.user_details?.last_name ?? "")"
                self.lbl_Address.text = obj.user_details?.country_name ?? ""
                self.lbl_Status.text = "Status: \(obj.status ?? "")"
                self.user_ID = obj.user_id ?? ""
                self.lbl_Date.text = obj.date ?? ""
                self.lbl_Time.text = obj.time ?? ""
                
                self.userName = "\(obj.user_details?.first_name ?? "") \(obj.user_details?.last_name ?? "")"
                self.receiverId = obj.user_details?.id ?? ""
                
                if let obj_Img = obj.user_details?.image {
                    if Router.BASE_IMAGE_URL != obj_Img {
                        Utility.setImageWithSDWebImage(obj_Img, self.profile_Img)
                    } else {
                        self.profile_Img.image = R.image.placeholder()
                    }
                }
            } else {
                self.lbl_Name.text = "\(obj.provider_details?.first_name ?? "") \(obj.provider_details?.last_name ?? "")"
                self.lbl_Address.text = obj.provider_details?.country_name ?? ""
                self.lbl_Status.text = "Status: \(obj.status ?? "")"
                self.user_ID = obj.user_id ?? ""
                self.lbl_Date.text = obj.date ?? ""
                self.lbl_Time.text = obj.time ?? ""
                
                self.userName = "\(obj.provider_details?.first_name ?? "") \(obj.provider_details?.last_name ?? "")"
                self.receiverId = obj.provider_details?.id ?? ""
                
                if let obj_Img = obj.provider_details?.image {
                    if Router.BASE_IMAGE_URL != obj_Img {
                        Utility.setImageWithSDWebImage(obj_Img, self.profile_Img)
                    } else {
                        self.profile_Img.image = R.image.placeholder()
                    }
                }
            }
        }
    }
}
