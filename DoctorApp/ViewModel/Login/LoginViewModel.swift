//
//  LoginViewModel.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 07/08/24.
//

import Foundation

class LoginViewModel {
    
    // Input properties
    var mobile: String = ""
    var password: String = ""
    
    // Output properties
    var errorMessage: String? {
        didSet {
            self.showErrorMessage?()
        }
    }
    
    var showErrorMessage: (() -> Void)?
    var loginSuccess: (() -> Void)?
    
    // Validate user input
    func validateInput() -> Bool {
        if mobile.isEmpty {
            errorMessage = "Please enter the valid email or mobile".localiz()
            return false
        } else if password.isEmpty {
            errorMessage = "Please enter the password".localiz()
            return false
        }
        return true
    }
    
    // Perform login
    func performLogin(vC: UIViewController) {
        guard validateInput() else { return }
        
        // Prepare parameters
        var paramDict: [String : AnyObject] = [:]
        paramDict["mobile"] = mobile as AnyObject
        paramDict["password"] = password as AnyObject
        paramDict["register_id"] = k.emptyString as AnyObject
        paramDict["ios_register_id"] = k.iosRegisterId as AnyObject
        paramDict["lat"] = kAppDelegate.CURRENT_LAT as AnyObject
        paramDict["lon"] = kAppDelegate.CURRENT_LON as AnyObject
        
        print(paramDict)
        
        // Call API
        Api.shared.login(vC, paramDict) { [weak self] responseData in
            guard let self = self else { return }
            k.userDefault.set(true, forKey: k.session.status)
            k.userDefault.set(responseData.id ?? "", forKey: k.session.userId)
            k.userDefault.set(responseData.email ?? "", forKey: k.session.userEmail)
            k.userDefault.set(responseData.type ?? "", forKey: k.session.type)
            self.loginSuccess?()
        }
    }
}
