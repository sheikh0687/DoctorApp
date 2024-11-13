//
//  SignupViewModel.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 07/08/24.
//

import Foundation

class SignupViewModel {
    
    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var mobile:String = ""
    var password:String = ""
    var confirmPassword:String = ""
    var address:String = ""
    var universityName:String = ""
    var strCheck:String = ""
    
    var errorMessage: String? {
        didSet {
            self.showErrorMessage?()
        }
    }
    
    var showErrorMessage: (() -> Void)?
    var signupSuccess: (() -> Void)?
    
    func isValidUserInput() -> Bool
    {
        
        if firstName.isEmpty {
            errorMessage = "Please enter the first name".localiz()
            return false
        } else if lastName.isEmpty {
            errorMessage = "Please enter the last name".localiz()
            return false
        } else if email.isEmpty {
            errorMessage = "Please enter the email".localiz()
            return false
        } else if mobile.isEmpty {
            errorMessage = "Please enter the mobile number".localiz()
            return false
        } else if password.isEmpty {
            errorMessage = "Please enter the password".localiz()
            return false
        } else if confirmPassword.isEmpty {
            errorMessage = "Please enter the confirm password".localiz()
            return false
        } else if password != confirmPassword {
            errorMessage = "Please enter the same password".localiz()
            return false
        } else if strCheck == "" {
            errorMessage = "Please check the Terms and Condition".localiz()
            return false
        }
        
        return true
    }
    
    func isValidProviderInput() -> Bool
    {
        
        if firstName.isEmpty {
            errorMessage = "Please enter the first name".localiz()
            return false
        } else if lastName.isEmpty {
            errorMessage = "Please enter the last name".localiz()
            return false
        } else if email.isEmpty {
            errorMessage = "Please enter the email".localiz()
            return false
        } else if mobile.isEmpty {
            errorMessage = "Please enter the mobile number".localiz()
            return false
        } else if password.isEmpty {
            errorMessage = "Please enter the password".localiz()
            return false
        } else if confirmPassword.isEmpty {
            errorMessage = "Please enter the confirm password".localiz()
            return false
        } else if password != confirmPassword {
            errorMessage = "Please enter the same password".localiz()
            return false
        } else if strCheck == "" {
            errorMessage = "Please check the Terms and Condition".localiz()
            return false
        } else if universityName.isEmpty {
            errorMessage = "Please enter the university name".localiz()
            return false
        }
        
        return true
    }
    
    
}
