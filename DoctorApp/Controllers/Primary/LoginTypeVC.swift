//
//  LogTypeVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 15/06/24.
//

import UIKit

class LoginTypeVC: UIViewController {
    
    @IBOutlet weak var patient_View: UIView!
    @IBOutlet weak var doctor_View: UIView!
    
    var type:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func btn_Patient(_ sender: UIButton) {
        self.patient_View.animateColorChange(to: R.color.button()!, uiViews: patient_View) {
            self.doctor_View.backgroundColor = UIColor.white
        }
        type = "USER"
    }
    
    @IBAction func btn_Doctor(_ sender: UIButton) {
        self.patient_View.backgroundColor = UIColor.white
        self.doctor_View.animateColorChange(to: R.color.button()!, uiViews: doctor_View) {}
        type = "PROVIDER"
    }
    
    @IBAction func btn_Next(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
