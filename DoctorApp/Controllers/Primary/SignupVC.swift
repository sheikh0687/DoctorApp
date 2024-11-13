//
//  SignupVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 13/06/24.
//

import UIKit
import CountryPickerView
import DropDown

class SignupVC: UIViewController {
    
    @IBOutlet weak var txt_CountryPicker: UITextField!
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Mobile: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    @IBOutlet weak var txt_Address: UITextView!
    @IBOutlet weak var txt_UniversityName: UITextField!
    @IBOutlet weak var btn_MaleOt: UIButton!
    @IBOutlet weak var btn_FemaleOt: UIButton!
    @IBOutlet weak var btn_SelectCountryOt: UIButton!
    @IBOutlet weak var view_University: UIView!
    
    weak var cpvTextField: CountryPickerView!
    var phoneKey:String! = ""
    
    var type:String!
    
    var dropDown = DropDown()
    
    var arr_Country: [Res_CountryList] = []
    
    var selectedCountryId:String!
    var selectedCountryName:String!
    var strCheck = ""
    var gender_Type = "Male"
    var dateOfBirth = ""
    
    var address = ""
    var lat = 0.0
    var lon = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCountryPicker()
        btn_MaleOt.setImage(R.image.ic_CheckedCircle_Black(), for: .normal)
        btn_FemaleOt.setImage(R.image.ic_Circle_Black(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.countryList()
        if type == "USER" {
            view_University.isHidden = true
        } else {
            view_University.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func configureCountryPicker()
    {
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 80, height: 14))
        cp.flagImageView.isHidden = true
        txt_CountryPicker.rightView = cp
        txt_CountryPicker.rightViewMode = .always
        txt_CountryPicker.leftView = nil
        txt_CountryPicker.leftViewMode = .never
        cpvTextField = cp
        let countryCode = "US"
        cpvTextField.setCountryByCode(countryCode)
        cp.delegate = self
        [cp].forEach {
            $0?.dataSource = self
        }
        phoneKey = cp.selectedCountry.phoneCode
        cp.countryDetailsLabel.font = UIFont.systemFont(ofSize: 12)
        cp.font = UIFont.systemFont(ofSize: 12)
    }
    
    @IBAction func btn_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureDropDown()
    {
        var arrCatId: [String] = []
        var arrCatName: [String] = []
        for val in arr_Country {
            arrCatId.append(val.id ?? "")
            arrCatName.append(val.name ?? "")
        }
        dropDown.anchorView = btn_SelectCountryOt
        dropDown.dataSource = arrCatName
        dropDown.backgroundColor = UIColor.white
        dropDown.bottomOffset = CGPoint(x: 0, y: 45)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCountryId = arrCatId[index]
            self.selectedCountryName = item
            self.btn_SelectCountryOt.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func btn_SelectCountry(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func btn_AddressPicker(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "AddressPickerVC") as! AddressPickerVC
        vc.locationPickedBlock = {(addressCordinate, latVal, lonVal, addressVal) in
            self.txt_Address.text = addressVal
            self.address = addressVal
            self.lat = latVal
            self.lon = lonVal
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btn_Gender(_ sender: UIButton) {
        if sender.tag == 0 {
            btn_MaleOt.setImage(R.image.ic_CheckedCircle_Black(), for: .normal)
            btn_FemaleOt.setImage(R.image.ic_Circle_Black(), for: .normal)
            gender_Type = "Male"
        } else {
            btn_FemaleOt.setImage(R.image.ic_CheckedCircle_Black(), for: .normal)
            btn_MaleOt.setImage(R.image.ic_Circle_Black(), for: .normal)
            gender_Type = "Female"
        }
    }
    
    @IBAction func btn_DateOfBirth(_ sender: UIButton) {
        datePickerTapped(strFormat: "yyyy/MM/dd", mode: .date) { dateString in
            self.dateOfBirth = dateString
            sender.setTitle(dateString, for: .normal)
        }
    }
    
    @IBAction func btn_Check(_ sender: UIButton) {
     
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(R.image.rectangleUncheck(), for: .normal)
            strCheck = ""
        } else {
            sender.isSelected = true
            sender.setImage(R.image.rectangleChecked(), for: .normal)
            strCheck = "Checked"
        }
    }
    
    @IBAction func btn_Register(_ sender: UIButton) {
        if type == "USER" {
            if isValidUserInput() {
                self.verify_UserMobile()
            }
        } else {
            if isValidProviderInput() {
                self.verify_UserMobile()
            }
        }
    }
    
    
    func isValidUserInput() -> Bool
    {
        var isValid: Bool = true
        var error_Message: String = ""
        
        if (txt_FirstName.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the first name".localiz()
        } else if (txt_LastName.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the last name".localiz()
        } else if (txt_Email.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the email".localiz()
        } else if (txt_Mobile.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the mobile number".localiz()
        } else if (txt_Password.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the password".localiz()
        } else if (txt_ConfirmPassword.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the confirm password".localiz()
        } else if txt_Password.text != txt_ConfirmPassword.text {
            isValid = false
            error_Message = "Please enter the same password".localiz()
        } else if strCheck == "" {
            isValid = false
            error_Message = "Please check the Terms and Condition".localiz()
        }
        
        if (isValid == false)
        {
            Utility.showAlertMessage(withTitle: k.appName, message: error_Message, delegate: nil, parentViewController: self)
        }
        
        return isValid
    }
    
    func isValidProviderInput() -> Bool
    {
        var isValid: Bool = true
        var error_Message: String = ""
        
        if (txt_FirstName.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the first name".localiz()
        } else if (txt_LastName.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the last name".localiz()
        } else if (txt_Email.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the email".localiz()
        } else if (txt_Mobile.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the mobile number".localiz()
        } else if (txt_Password.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the password".localiz()
        } else if (txt_ConfirmPassword.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the confirm password".localiz()
        } else if txt_Password.text != txt_ConfirmPassword.text {
            isValid = false
            error_Message = "Please enter the same password".localiz()
        } else if strCheck == "" {
            isValid = false
            error_Message = "Please check the Terms and Condition".localiz()
        } else if (txt_UniversityName.text?.isEmpty)! {
            isValid = false
            error_Message = "Please enter the university name".localiz()
        }
        
        if (isValid == false)
        {
            Utility.showAlertMessage(withTitle: k.appName, message: error_Message, delegate: nil, parentViewController: self)
        }
        
        return isValid
    }
    
    @IBAction func btn_LoginNow(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignupVC {
    
    func countryList()
    {
        Api.shared.countryList(self) { responseData in
            if responseData.count > 0 {
                self.arr_Country = responseData
            } else {
                self.arr_Country = []
            }
            self.configureDropDown()
        }
    }
    
    func verify_UserMobile(shouldNavigate: Bool = true)
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["mobile_with_code"]       = "\(self.phoneKey ?? "")\(self.txt_Mobile.text!)" as AnyObject
        paramDict["mobile"]                 = self.txt_Mobile.text as AnyObject
        paramDict["email"]                  = self.txt_Email.text as AnyObject
        paramDict["type"]                   = type as AnyObject
        
        print(paramDict)
        
        Api.shared.verify_MobileNumber(self, paramDict) { responseData in
            self.collect_Data()
            if shouldNavigate {
                let vc = R.storyboard.main().instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                vc.verificationCode = responseData.code ?? ""
                vc.cloResend =  {() in
                    self.verify_UserMobile(shouldNavigate: false)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collect_Data()
    {
        dictSignup["first_name"] = self.txt_FirstName.text as AnyObject
        dictSignup["last_name"] = self.txt_LastName.text as AnyObject
        dictSignup["email"] = self.txt_Email.text as AnyObject
        dictSignup["country_id"] = self.selectedCountryId as AnyObject
        dictSignup["country_name"] = self.selectedCountryName as AnyObject
        dictSignup["cat_id"] = k.emptyString as AnyObject
        dictSignup["cat_name"] = k.emptyString as AnyObject
        dictSignup["password"] = self.txt_Password.text as AnyObject
        dictSignup["register_id"] = k.emptyString as AnyObject
        dictSignup["ios_register_id"] = k.iosRegisterId as AnyObject
        dictSignup["type"] = type as AnyObject
        dictSignup["gender"] = gender_Type as AnyObject
        dictSignup["address"] = address as AnyObject
        dictSignup["lat"] = lat as AnyObject
        dictSignup["lon"] = lon as AnyObject
        dictSignup["university_name"] = self.txt_UniversityName.text as AnyObject
        dictSignup["cancer_type"] = k.emptyString as AnyObject
        dictSignup["cancer_subtypeid"] = k.emptyString as AnyObject
        dictSignup["cancer_subtypename"] = k.emptyString as AnyObject
        dictSignup["dob"] = self.dateOfBirth as AnyObject
        dictSignup["mobile"] = self.txt_Mobile.text as AnyObject
        dictSignup["mobile_with_code"] = phoneKey + txt_Mobile.text! as AnyObject
    }
}

extension SignupVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneKey = country.phoneCode
    }
}

extension SignupVC: CountryPickerViewDataSource {
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        var countries = [Country]()
        ["GB"].forEach { code in
            if let country = countryPickerView.getCountryByCode(code) {
                countries.append(country)
            }
        }
        return countries
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "Preferred title"
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
