//
//  PaymentVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 29/07/24.
//

import UIKit

class PaymentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btn_Back(_ sender: UIButton) {
        
    }
    
    @IBAction func btn_PayContinue(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "FatoorahPaymentVC") as! FatoorahPaymentVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
