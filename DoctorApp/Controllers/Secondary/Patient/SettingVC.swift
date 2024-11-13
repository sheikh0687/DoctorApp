//
//  UserSettingVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var view_Degree: UIView!
    @IBOutlet weak var view_Weekly: UIView!
    @IBOutlet weak var view_CrabConnection: UIView!
    
    @IBOutlet weak var lbl_DegreeText: UILabel!
    
    let connection_Type = k.userDefault.value(forKey: k.session.type) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if connection_Type == "USER" {
            self.view_Degree.isHidden = false
            self.view_Weekly.isHidden = true
            self.view_CrabConnection.isHidden = true
            self.lbl_DegreeText.text = "Upload Reports"
        } else {
            self.view_Degree.isHidden = false
            self.view_Weekly.isHidden = false
            self.view_CrabConnection.isHidden = true
            self.lbl_DegreeText.text = "Add Your Degree’s"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileDetails()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btn_EditProfile(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_ChangePassword(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ChangePasswodVC") as! ChangePasswodVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Review(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "UserReviewVC") as! UserReviewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_WalletHistory(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Language(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_VirtualCrab(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "VirtualCrabConnectionVC") as! VirtualCrabConnectionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Help(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Logout(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: k.session.userId)
        UserDefaults.standard.synchronize()
        Swicther.updateRootVC()
    }
    
    @IBAction func btn_AddDegree(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "QualificationVC") as! QualificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_SetWeeklyAvailability(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "WeeklyScheduleVC") as! WeeklyScheduleVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SettingVC {
    
    func profileDetails()
    {
        Api.shared.profile(self) { responseData in
            let obj = responseData
            self.lbl_Name.text = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImage(obj.image ?? "", self.profile_Img)
            } else {
                self.profile_Img.image = R.image.placeholder()
            }
        }
    }
}
