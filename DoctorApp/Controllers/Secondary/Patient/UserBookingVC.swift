//
//  UserBookingVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 15/06/24.
//

import UIKit
import SkeletonView

class UserBookingVC: UIViewController {
    
    @IBOutlet weak var booking_TableVw: UITableView!
    @IBOutlet weak var top_View: UIView!
    @IBOutlet weak var btn_OngoingOt: UIButton!
    @IBOutlet weak var btn_HistoryOt: UIButton!
    @IBOutlet weak var btn_PendingOt: UIButton!
    
    var array_UserBookApnmt: [Res_UserBookAppoinment] = []
    var status_Type:String = "Pending"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        top_View.clipsToBounds = true
        top_View.layer.cornerRadius = 20
        top_View.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.booking_TableVw.register(UINib(nibName: "UserBookingCell", bundle: nil), forCellReuseIdentifier: "UserBookingCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        booking_Appointment()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btn_BookingStatus(_ sender: UIButton) {
        if sender.tag == 0 {
            btn_PendingOt.setTitleColor(R.color.top(), for: .normal)
            btn_OngoingOt.setTitleColor(UIColor.darkGray, for: .normal)
            btn_HistoryOt.setTitleColor(UIColor.darkGray, for: .normal)
            status_Type = "Pending"
            self.booking_Appointment()
        } else if sender.tag == 1 {
            btn_OngoingOt.setTitleColor(R.color.top(), for: .normal)
            btn_PendingOt.setTitleColor(UIColor.darkGray, for: .normal)
            btn_HistoryOt.setTitleColor(UIColor.darkGray, for: .normal)
            status_Type = "Current"
            self.booking_Appointment()
        } else {
            btn_HistoryOt.setTitleColor(R.color.top(), for: .normal)
            btn_OngoingOt.setTitleColor(UIColor.darkGray, for: .normal)
            btn_PendingOt.setTitleColor(UIColor.darkGray, for: .normal)
            status_Type = "Complete"
            self.booking_Appointment()
        }
    }
}

extension UserBookingVC {
    
    func booking_Appointment()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["status"] = status_Type as AnyObject
        
        print(paramDict)
        
        Api.shared.user_BookingAppointment(self, paramDict) { responseData in
            let obj = responseData
            if obj.status == "1" {
                if let result = obj.result {
                    self.array_UserBookApnmt = result
                    self.booking_TableVw.backgroundView = UIView()
                    self.booking_TableVw.reloadData()
                }
            } else {
                self.array_UserBookApnmt = []
                self.booking_TableVw.backgroundView = UIView()
                self.booking_TableVw.reloadData()
                Utility.noDataFound("No Past Order", "Currently you have no past order\nPost new order and track your order.", tableViewOt: self.booking_TableVw, parentViewController: self)
            }
        }
    }
}

extension UserBookingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array_UserBookApnmt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserBookingCell", for: indexPath) as! UserBookingCell
        cell.showAnimatedSkeleton()
        
        let obj = self.array_UserBookApnmt[indexPath.row]
        
        // Common cell configuration
        cell.lbl_Name.text = "\(obj.provider_details?.first_name ?? "") \(obj.provider_details?.last_name ?? "")"
        cell.lbl_Address.text = obj.provider_details?.country_name ?? ""
        cell.lbl_CancerType.text = "\(obj.provider_details?.sub_cat_name ?? "") | \(obj.provider_details?.university_name ?? "")"
        cell.lbl_Date.text = obj.date ?? ""
        cell.lbl_Time.text = obj.time ?? ""
        
        if let profile_Img = obj.provider_details?.image {
            if Router.BASE_IMAGE_URL != profile_Img {
                Utility.setImageWithSDWebImage(profile_Img, cell.profile_Img)
            } else {
                cell.profile_Img.image = R.image.placeholder_Blank()
            }
        }
        
        if self.status_Type == "Current" {
            cell.btn_GiveRatingView.isHidden = true
            cell.lbl_RefrenceCode.text = "Reference Code: #- \(obj.unique_code ?? "")"
            cell.lbl_RefrenceCode.textColor = R.color.top()
        } else {
            cell.lbl_RefrenceCode.text = "Status: \(obj.status ?? "")"
            cell.lbl_RefrenceCode.textColor = .black
            
            if obj.rating_review_status != "YES" {
                cell.btn_GiveRatingView.isHidden = false
                cell.clo_GiveRating = {() in
                    let vc = R.storyboard.main().instantiateViewController(withIdentifier: "DoRatingVC") as! DoRatingVC
                    vc.provider_Id = obj.provider_id ?? ""
                    vc.request_Id = obj.id ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                cell.btn_GiveRatingView.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "PatientInfoVC") as! PatientInfoVC
        vc.request_Id = self.array_UserBookApnmt[indexPath.row].id ?? ""
        vc.type = "USER"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
