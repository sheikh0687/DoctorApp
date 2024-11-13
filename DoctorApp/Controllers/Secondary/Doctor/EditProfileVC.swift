//
//  EditProfileVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 14/06/24.
//

import UIKit
import CountryPickerView
import LanguageManager_iOS

class EditProfileVC: UIViewController {

    @IBOutlet weak var btn_ProfileImg: UIButton!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_CountryPicker: UITextField!
    @IBOutlet weak var txt_Mobile: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_UniversityName: UITextField!
    @IBOutlet weak var txt_Experience: UITextField!
    @IBOutlet weak var txt_EnterFee: UITextField!
    @IBOutlet weak var txt_Gender: UITextField!
    @IBOutlet weak var txt_DateOfBirth: UITextField!
    @IBOutlet weak var view_University: UIView!
    @IBOutlet weak var view_Experience: UIView!
    @IBOutlet weak var view_Fee: UIView!
    @IBOutlet weak var lbl_Docs: UILabel!
    @IBOutlet weak var btn_UploadDocsOt: UIButton!
    
    weak var cpvTextField: CountryPickerView!
    var phoneKey:String! = ""
    
    var image = UIImage()
    
    let connection_Type = k.userDefault.value(forKey: k.session.type) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profile()
        configureCountryView()
        if connection_Type == "USER" {
            view_University.isHidden = true
            view_Experience.isHidden = true
            view_Fee.isHidden = true
            lbl_Docs.isHidden = true
            btn_UploadDocsOt.isHidden = true
        } else {
            view_University.isHidden = false
            view_Experience.isHidden = false
            view_Fee.isHidden = false
            lbl_Docs.isHidden = false
            btn_UploadDocsOt.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Edit Profile", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func configureCountryView() {
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 80, height: 14))
        cp.flagImageView.isHidden = true
        if LanguageManager.shared.currentLanguage == .ar {
            txt_CountryPicker.leftView = cp
            txt_CountryPicker.leftViewMode = .always
        } else {
            txt_CountryPicker.rightView = cp
            txt_CountryPicker.rightViewMode = .always
        }
        self.cpvTextField = cp
        let countryCode = "US"
        self.cpvTextField.setCountryByCode(countryCode)
        cp.delegate = self
        [cp].forEach {
            $0?.dataSource = self
        }
        self.phoneKey = cp.selectedCountry.phoneCode
        cp.countryDetailsLabel.font = UIFont.systemFont(ofSize: 12)
        cp.font = UIFont.systemFont(ofSize: 12)
    }
    
    @IBAction func btn_ImagePicker(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btn_AddDegree(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "QualificationVC") as! QualificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Update(_ sender: UIButton) {
        if allInputsThere() {
            updateProfile()
        }
    }
    
    func allInputsThere() -> Bool {
        var isValid: Bool = true
        var error_Message: String = ""
        
        if txt_FirstName.hasText && txt_LastName.hasText && txt_Email.hasText && txt_Mobile.hasText && txt_UniversityName.hasText && txt_Experience.hasText && txt_EnterFee.hasText && txt_Gender.hasText && txt_DateOfBirth.hasText {
            print("There is no text are empty")
        } else {
            isValid = false
            error_Message = "Please enter the required details"
        }
        
        if (isValid == false)
        {
            Utility.showAlertMessage(withTitle: k.appName, message: error_Message, delegate: nil, parentViewController: self)
        }
        
        return isValid
    }
}

extension EditProfileVC {
    
    func profile()
    {
        Api.shared.profile(self) { responseData in
            let obj = responseData
            self.lbl_Name.text = "\(obj.first_name ?? "")"
            self.lbl_Email.text = obj.email ?? ""
            self.txt_FirstName.text = obj.first_name ?? ""
            self.txt_Mobile.text = obj.mobile ?? ""
            self.txt_LastName.text = obj.last_name ?? ""
            self.txt_Email.text = obj.email ?? ""
            self.txt_UniversityName.text = obj.university_name ?? ""
            self.txt_Experience.text = obj.experience_year ?? ""
            self.txt_EnterFee.text = obj.consultant_fees ?? ""
            self.txt_Gender.text = obj.gender ?? ""
            self.txt_DateOfBirth.text = obj.dob ?? ""
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImageOnButton(obj.image ?? "", self.btn_ProfileImg)
            } else {
                self.btn_ProfileImg.setImage(R.image.placeholder(), for: .normal)
            }
        }
    }
    
    func updateProfile()
    {
        var paramProfile: [String : String] = [:]
        paramProfile["user_id"] = k.userDefault.value(forKey: k.session.userId) as? String
        paramProfile["first_name"] = self.txt_FirstName.text
        paramProfile["last_name"] = self.txt_LastName.text
        paramProfile["mobile"] = self.txt_Mobile.text
        paramProfile["cat_id"] = k.emptyString
        paramProfile["cat_name"] = k.emptyString
        paramProfile["university_name"] = self.txt_UniversityName.text
        paramProfile["experience_year"] = self.txt_Experience.text
        paramProfile["consultant_fees"] = self.txt_EnterFee.text
        paramProfile["lat"] = k.emptyString
        paramProfile["lon"] = k.emptyString
        paramProfile["gender"] = self.txt_Gender.text
        paramProfile["dob"] = self.txt_DateOfBirth.text
        
        print(paramProfile)
        
        var paramProfileImg: [String : UIImage] = [:]
        paramProfileImg["image"] = self.image
        
        print(paramProfileImg)
        
        Api.shared.update_ProviderProfile(self, paramProfile, images: paramProfileImg, videos: [:]) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Your profile updates successfully", delegate: nil, parentViewController: self) { bool in
                self.profile()
                self.dismiss(animated: true)
            }
        }
    }
}


extension EditProfileVC: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneKey = country.phoneCode
    }
}

extension EditProfileVC: CountryPickerViewDataSource {
    
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
