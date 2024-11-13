//
//  ChangePasswodVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit

class ChangePasswodVC: UIViewController {
    
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_NewPassword: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Change Password", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_Submit(_ sender: UIButton) {
        if isValidPassword() {
            update_Password()
        }
    }
    
    func isValidPassword() -> Bool
    {
        var isValid: Bool = true
        var error_Message:String = ""
        
        if (txt_Password.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the valid passowrd"
        } else if (txt_NewPassword.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the new password"
        } else if (txt_ConfirmPassword.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the confirm password"
        } else if txt_NewPassword.text != txt_ConfirmPassword.text {
            isValid = false
            error_Message = "Please enter the same password"
        }
        
        if (isValid == false)
        {
            Utility.showAlertMessage(withTitle: k.appName, message: error_Message, delegate: nil, parentViewController: self)
        }
        
        return isValid
    }
}

extension ChangePasswodVC {
    
    func update_Password()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["password"] = self.txt_NewPassword.text as AnyObject
        paramDict["old_password"] = self.txt_Password.text as AnyObject
        
        print(paramDict)
        
        Api.shared.update_Password(self, paramDict) { responseData in
            let obj = responseData
            if obj.status == "1" {
                Utility.showAlertWithAction(withTitle: k.appName, message: "Your password has been updated successfully", delegate: nil, parentViewController: self) { bool in
                    Swicther.updateRootVC()
                }
            } else {
                self.alert(alertmessage: obj.result ?? "")
            }
        }
    }
    
}
