//
//  DoRatingVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit
import Cosmos

class DoRatingVC: UIViewController {

    @IBOutlet weak var doctorPunctualRating: CosmosView!
    @IBOutlet weak var doctorLanguageRating: CosmosView!
    @IBOutlet weak var treatmentRating: CosmosView!
    @IBOutlet weak var recommendDoctorRating: CosmosView!
    @IBOutlet weak var txt_AnyOtherFeedback: UITextView!
    
    var provider_Id:String = ""
    var request_Id:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Give Rating", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_Done(_ sender: UIButton) {
        if isValidInputs() {
            doRatingReview()
        }
    }
}

extension DoRatingVC {
    
    func isValidInputs() -> Bool
    {
        var isValid:Bool = true
        var errorMessage:String = ""
        
        if (doctorPunctualRating.rating.isZero) {
            isValid = false
            errorMessage = "Please select the rating"
        } else if (doctorLanguageRating.rating.isZero) {
            isValid = false
            errorMessage = "Please select the rating"
        } else if (treatmentRating.rating.isZero) {
            isValid = false
            errorMessage = "Please select the rating"
        } else if (recommendDoctorRating.rating.isZero) {
            isValid = false
            errorMessage = "Please select the rating"
        } else if (txt_AnyOtherFeedback.text.isEmpty) {
            isValid = false
            errorMessage = "Please enter the feedback"
        }
        
        if (isValid == false) {
            self.alert(alertmessage: errorMessage)
        }
        
        return isValid
    }
    
    func doRatingReview()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["form_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["feedback"] = txt_AnyOtherFeedback.text as AnyObject
        paramDict["rating_punctual"] = doctorPunctualRating.rating as AnyObject
        paramDict["to_id"] = provider_Id as AnyObject
        paramDict["rating_language"] = doctorLanguageRating.rating as AnyObject
        paramDict["type"] = k.userDefault.value(forKey: k.session.type) as AnyObject
        paramDict["request_id"] = request_Id as AnyObject
        paramDict["rating_treatment"] = treatmentRating.rating as AnyObject
        paramDict["rating_recommend"] = recommendDoctorRating.rating as AnyObject
        
        print(paramDict)
        
        Api.shared.requestToAddRating(self, paramDict) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Rating completed", delegate: nil, parentViewController: self) { bool in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

//https://techimmense.in/crabconnect/webservice/add_rating_review_by_order?&feedback=xsdf%20drd%20ffg%20ccf%20vg&rating_punctual=3.0&form_id=2&to_id=3&rating_language=4.0&type=USER&request_id=2&rating_treatment=1.0&rating_recommend=1.0
