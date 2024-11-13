//
//  LoginVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 13/06/24.
//

import UIKit
import CountryPickerView
import LanguageManager_iOS
import DropDown

class LoginVC: UIViewController {
    
    @IBOutlet weak var txt_Mobile: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var lbl_SelectLanguage: UILabel!
    @IBOutlet weak var btn_SelectLanguageOt: UIButton!
    
    weak var cpvTextField: CountryPickerView!
    var phoneKey:String! = ""
    
    var dropDown = DropDown()
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        self.setupLanguageTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btn_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_ForgotPassword(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupLanguageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropLanguage))
        lbl_SelectLanguage.isUserInteractionEnabled = true
        lbl_SelectLanguage.addGestureRecognizer(tapGesture)
    }
    
    @objc func dropLanguage()
    {
        dropDown.anchorView = lbl_SelectLanguage
        dropDown.show()
        dropDown.dataSource = ["English","Arabic","Bengali"]
        dropDown.bottomOffset = CGPoint(x: -5, y: 40)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbl_SelectLanguage.text = item
        }
    }
    
    private func setupBindings() {
        viewModel.showErrorMessage = { [weak self] in
            if let errorMessage = self?.viewModel.errorMessage {
                Utility.showAlertMessage(withTitle: k.appName, message: errorMessage, delegate: nil, parentViewController: self!)
            }
        }
        
        viewModel.loginSuccess = { [] in
            Swicther.updateRootVC()
        }
    }
    
    @IBAction func btn_Login(_ sender: UIButton) {
        viewModel.mobile = txt_Mobile.text ?? ""
        viewModel.password = txt_Password.text ?? ""
        viewModel.performLogin(vC: self)
    }
    
    @IBAction func btn_GoogleLogin(_ sender: UIButton) {
        print("Tapped GoogleLogin")
    }
    
    @IBAction func btn_Signup(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginTypeVC") as! LoginTypeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginVC: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneKey = country.phoneCode
    }
}

extension LoginVC: CountryPickerViewDataSource {
    
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
