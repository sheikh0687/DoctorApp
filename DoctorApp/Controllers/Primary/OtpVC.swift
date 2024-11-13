//
//  OtpVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 19/07/24.
//

import UIKit
import OTPFieldView

class OtpVC: UIViewController {
    
    @IBOutlet var otpTextFieldView: OTPFieldView!
    
    var verificationCode = ""
    var cloResend:(() -> Void)?
    var enteredOtp:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(verificationCode)
        setupOtpView()
    }
    
    func setupOtpView() {
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 1
        self.otpTextFieldView.defaultBorderColor = UIColor.separator
        self.otpTextFieldView.filledBorderColor = #colorLiteral(red: 1, green: 0.7725490196, blue: 0.4509803922, alpha: 1)
        self.otpTextFieldView.cursorColor = UIColor.red
        self.otpTextFieldView.displayType = .roundedCorner
        self.otpTextFieldView.fieldSize = 40
        self.otpTextFieldView.separatorSpace = 8
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }
    
    @IBAction func btn_Resend(_ sender: UIButton) {
        cloResend?()
    }
    
    @IBAction func btn_Submit(_ sender: UIButton) {
        if verificationCode != enteredOtp {
            self.alert(alertmessage: "Please enter the valid verification code")
        } else {
            registerUser()
        }
    }
}

extension OtpVC {
    
    func registerUser()
    {
        Api.shared.signup(self, dictSignup) { responseData in
            Utility.showAlertWithAction(withTitle: "Welcome to CrabConnection", message: "Congratulation your account has been created successfully", delegate: nil, parentViewController: self) { bool in
                k.userDefault.set(true, forKey: k.session.status)
                k.userDefault.set(responseData.id ?? "", forKey: k.session.userId)
                k.userDefault.set(responseData.email ?? "", forKey: k.session.userEmail)
                k.userDefault.set(responseData.type ?? "", forKey: k.session.type)
                Swicther.updateRootVC()
            }
        }
    }
}

extension OtpVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        self.enteredOtp = otpString
    }
}
