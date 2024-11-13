//
//  DoctorDetailVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit

class DoctorDetailVC: UIViewController {

    @IBOutlet weak var review_TableVw: UITableView!
    @IBOutlet weak var tableVw_Height: NSLayoutConstraint!
    @IBOutlet weak var degree_TableVw: UITableView!
    @IBOutlet weak var degree_TableHeight: NSLayoutConstraint!
    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_CountryNdCancerType: UILabel!
    @IBOutlet weak var lbl_DateNdTime: UILabel!
    @IBOutlet weak var lbl_YearOfExp: UILabel!
    @IBOutlet weak var lbl_NumOfTreat: UILabel!
    @IBOutlet weak var lbl_HourlyRate: UILabel!
    
    var provider_Id:String = ""
    
    var array_Degrees: [Doctor_degree] = []
    var arrayOfRatigns: [Res_RatingReview] = []
    
    var provider_Detail: Res_ProviderDetails?
    
    var consultantFee:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        review_TableVw.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        degree_TableVw.register(UINib(nibName: "DegreeCell", bundle: nil), forCellReuseIdentifier: "DegreeCell")
        provider_Details()
        fetchRatings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Doctor's Details", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_SeeAll(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "UserReviewVC") as! UserReviewVC
        vc.arrayOfRatingReview = self.arrayOfRatigns
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_BookAppointment(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "AppointmentDetailVC") as! AppointmentDetailVC
        vc.provider_Id = self.provider_Id
        vc.resProviderDetail = self.provider_Detail
        vc.consultant_Fee = self.consultantFee
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DoctorDetailVC {
    
    func provider_Details()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["provider_id"] = provider_Id as AnyObject
        paramDict["lat"] = k.emptyString as AnyObject
        paramDict["lon"] = k.emptyString as AnyObject
        
        print(paramDict)
        
        Api.shared.provider_Info(self, paramDict) { responseData in
            let obj = responseData
            self.provider_Detail = responseData
            self.lbl_Name.text = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
            self.lbl_CountryNdCancerType.text = "\(obj.country_name ?? "")\n\(obj.sub_cat_name ?? "") | \(obj.university_name ?? "")"
            self.lbl_DateNdTime.text = "\(obj.open_time ?? "") - \(obj.close_time ?? "")"
            
            self.lbl_YearOfExp.text = "\(obj.experience_year ?? "") Yr"
            self.lbl_HourlyRate.text = "$\(obj.consultant_fees ?? "")"
            
            self.consultantFee = obj.consultant_fees ?? ""
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImage(obj.image ?? "", self.profile_Img)
            } else {
                self.profile_Img.image = R.image.placeholder()
            }
            
            if let obj_doctorDegree = responseData.doctor_degree {
                if obj_doctorDegree.count > 0 {
                    self.array_Degrees = obj_doctorDegree
                    self.degree_TableHeight.constant = CGFloat(self.array_Degrees.count * 50)
                } else {
                    self.array_Degrees = []
                }
                self.degree_TableVw.reloadData()
            }
        }
    }
    
    func fetchRatings()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = provider_Id as AnyObject
        
        Api.shared.requestToRatingReview(self, paramDict) { [self] responseData in
            if responseData.count > 0 {
                self.arrayOfRatigns = responseData
                self.tableVw_Height.constant = CGFloat(self.arrayOfRatigns.count * 140)
            } else {
                self.arrayOfRatigns = []
            }
            self.review_TableVw.reloadData()
        }
    }
}

extension DoctorDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == degree_TableVw {
            return self.array_Degrees.count
        } else {
            return self.arrayOfRatigns.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == degree_TableVw {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DegreeCell", for: indexPath) as! DegreeCell
            let obj = self.array_Degrees[indexPath.row]
            cell.lbl_Date.isHidden = true
            cell.main_Vw.backgroundColor = .clear
            cell.lbl_Name.text = obj.name ?? ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            
            let obj = self.arrayOfRatigns[indexPath.row]
            let userName = "\(obj.form_details?.first_name ?? "") \(obj.form_details?.last_name ?? "")"
            cell.lbl_UserName.text = userName
            cell.lbl_DateTime.text = obj.date_time ?? ""
            cell.lbl_RatingCount.text = obj.rating ?? ""
            cell.ratingStar.rating = Double(obj.rating ?? "") ?? 0.0
            cell.lbl_Feedback.text = obj.feedback ?? ""
            
            if let userImg = obj.form_details?.image {
                if Router.BASE_IMAGE_URL != userImg {
                    Utility.setImageWithSDWebImage(userImg, cell.user_Img)
                } else {
                    cell.user_Img.image = R.image.placeholder_Blank()
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == degree_TableVw {
            return 50
        } else {
            return 140
        }
    }
}
