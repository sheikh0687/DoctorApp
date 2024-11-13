//
//  ForgotPasswordVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 21/06/24.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txt_Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Forgot Password", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_Send(_ sender: UIButton) {
        if self.txt_Email.hasText {
            retrieve_Password()
        } else {
            self.alert(alertmessage: "Please enter the valid email")
        }
    }
}

extension ForgotPasswordVC {
    
    func retrieve_Password()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["email"] = self.txt_Email.text as AnyObject
        
        print(paramDict)
        
        Api.shared.forgot_Password(self, paramDict) { responseData in
            if responseData.status == "1" {
                Utility.showAlertWithAction(withTitle: k.appName, message: "New password has been sent to yout email", delegate: nil, parentViewController: self) { bool in
                    self.dismiss(animated: true)
                }
            } else {
                self.alert(alertmessage: responseData.result ?? "")
            }
        }
    }
}
