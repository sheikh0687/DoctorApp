//
//  HomeVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 13/06/24.
//

import UIKit
import SkeletonView

class HomeVC: UIViewController {

    @IBOutlet weak var view_Address: UIView!
    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var appointment_TableVw: UITableView!
    @IBOutlet weak var btn_PendingOt: UIButton!
    @IBOutlet weak var btn_OngoingOt: UIButton!
    @IBOutlet weak var btn_CompleteOt: UIButton!
    
    var array_BookAppointment: [Res_BookAppoint] = []
    
    var status:String = "Pending"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_Address.clipsToBounds = true
        view_Address.layer.cornerRadius = 20
        view_Address.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        appointment_TableVw.register(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
        self.book_Appoinment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btn_BookingStatus(_ sender: UIButton) {
        if sender.tag == 0 {
            btn_PendingOt.setTitleColor(R.color.top(), for: .normal)
            btn_OngoingOt.setTitleColor(UIColor.darkGray, for: .normal)
            btn_CompleteOt.setTitleColor(UIColor.darkGray, for: .normal)
            status = "Pending"
            self.book_Appoinment()
        } else if sender.tag == 1 {
            btn_OngoingOt.setTitleColor(R.color.top(), for: .normal)
            btn_PendingOt.setTitleColor(UIColor.darkGray, for: .normal)
            btn_CompleteOt.setTitleColor(UIColor.darkGray, for: .normal)
            status = "Current"
            self.book_Appoinment()
        } else {
            btn_CompleteOt.setTitleColor(R.color.top(), for: .normal)
            btn_PendingOt.setTitleColor(UIColor.darkGray, for: .normal)
            btn_OngoingOt.setTitleColor(UIColor.darkGray, for: .normal)
            status = "Complete"
            self.book_Appoinment()
        }
    }
}

extension HomeVC {
    
    func book_Appoinment()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["provider_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["status"] = status as AnyObject
        
        print(paramDict)
        
        Api.shared.book_Appoinment(self, paramDict) { responseData in
            let obj = responseData
            if obj.status == "1" {
                if let result = obj.result {
                    self.array_BookAppointment = result
                    self.appointment_TableVw.backgroundView = UIView()
                    self.appointment_TableVw.reloadData()
                }
            } else {
                self.array_BookAppointment = []
                self.appointment_TableVw.backgroundView = UIView()
                self.appointment_TableVw.reloadData()
                Utility.noDataFound("No Past Order", "Currently you have no past order\nPost new order and track your order.", tableViewOt: self.appointment_TableVw, parentViewController: self)
            }
        }
    }
    
    func profile()
    {
        Api.shared.profile(self) { responseData in
            let obj = responseData
            self.lbl_Name.text = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImage(obj.image ?? "", self.profile_Img)
            } else {
                self.profile_Img.image = R.image.placeholder_Blank()
            }
        }
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_BookAppointment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        cell.showAnimatedSkeleton()
        if status == "Pending" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell.btn_AcceptOt.isHidden = false
                let obj = self.array_BookAppointment[indexPath.row]
                cell.lbl_UserName.text = "\(obj.user_details?.first_name ?? "") \(obj.user_details?.last_name ?? "")"
                cell.lbl_UniqueCode.text = "Id: #- \(obj.unique_code ?? "")"
                cell.lbl_UserCountryName.text = obj.user_details?.country_name ?? ""
                cell.lbl_Age.text = "\(obj.user_details?.age ?? "") years old"
                cell.lbl_Desease.text = obj.user_details?.sub_cat_name ?? ""
                cell.lbl_Date.text = obj.date ?? ""
                cell.lbl_Time.text = obj.time ?? ""
                cell.lbl_Status.text = "Pending"
                
                if let obj_Img = obj.user_details?.image {
                    if Router.BASE_IMAGE_URL != obj_Img {
                        Utility.setImageWithSDWebImage(obj_Img, cell.user_Img)
                    } else {
                        cell.user_Img.image = R.image.placeholder()
                    }
                }
                
                cell.cloAccept = {() in
                    
                }
                
                cell.hideSkeleton()
            }
        } else if status == "Current" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let obj = self.array_BookAppointment[indexPath.row]
                cell.btn_AcceptOt.isHidden = true
                cell.lbl_UserName.text = "\(obj.user_details?.first_name ?? "") \(obj.user_details?.last_name ?? "")"
                cell.lbl_UniqueCode.text = "Id: #- \(obj.unique_code ?? "")"
                cell.lbl_UserCountryName.text = obj.user_details?.country_name ?? ""
                cell.lbl_Age.text = "\(obj.user_details?.age ?? "") years old"
                cell.lbl_Desease.text = obj.user_details?.sub_cat_name ?? ""
                cell.lbl_Date.text = obj.date ?? ""
                cell.lbl_Time.text = obj.time ?? ""
                cell.lbl_Status.text = "Current"
                
                if let obj_Img = obj.user_details?.image {
                    if Router.BASE_IMAGE_URL != obj_Img {
                        Utility.setImageWithSDWebImage(obj_Img, cell.user_Img)
                    } else {
                        cell.user_Img.image = R.image.placeholder()
                    }
                }
                
                cell.hideSkeleton()
            }
        } else {
            let obj = self.array_BookAppointment[indexPath.row]
            cell.btn_AcceptOt.isHidden = true
            cell.lbl_UserName.text = "\(obj.user_details?.first_name ?? "") \(obj.user_details?.last_name ?? "")"
            cell.lbl_UniqueCode.text = "Id: #- \(obj.unique_code ?? "")"
            cell.lbl_UserCountryName.text = obj.user_details?.country_name ?? ""
            cell.lbl_Age.text = "\(obj.user_details?.age ?? "") years old"
            cell.lbl_Desease.text = obj.user_details?.sub_cat_name ?? ""
            cell.lbl_Date.text = obj.date ?? ""
            cell.lbl_Time.text = obj.time ?? ""
            cell.lbl_Status.text = "Complete"
            
            if let obj_Img = obj.user_details?.image {
                if Router.BASE_IMAGE_URL != obj_Img {
                    Utility.setImageWithSDWebImage(obj_Img, cell.user_Img)
                } else {
                    cell.user_Img.image = R.image.placeholder()
                }
            }
            
            cell.hideSkeleton()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "PatientInfoVC") as! PatientInfoVC
        vc.request_Id = self.array_BookAppointment[indexPath.row].id ?? ""
        vc.type = "PROVIDER"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

