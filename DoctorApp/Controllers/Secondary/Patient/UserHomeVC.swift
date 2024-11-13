//
//  UserHomeVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 15/06/24.
//

import UIKit

class UserHomeVC: UIViewController {

    @IBOutlet weak var doctor_TableVw: UITableView!
    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    
    var array_ProviderList: [Res_ProviderList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctor_TableVw.register(UINib(nibName: "DoctorDetailCell", bundle: nil), forCellReuseIdentifier: "DoctorDetailCell")
        profile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        providerList()
    }
    
    @IBAction func btn_SeeAll(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "DoctorInfoVC") as! DoctorInfoVC
        vc.array_AllProviderList = self.array_ProviderList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserHomeVC {
    
    func profile()
    {
        Api.shared.profile(self) { responseData in
            let obj = responseData
            self.lbl_Name.text = "\(obj.first_name ?? "") \(obj.last_name ?? "") (\(obj.age ?? "")years old)\n\(obj.sub_cat_name ?? "")"
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImage(obj.image ?? "", self.profile_Img)
            } else {
                self.profile_Img.image = R.image.placeholder()
            }
        }
    }
    
    func providerList()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["address"] = k.emptyString as AnyObject
        paramDict["lat"] = k.emptyString as AnyObject
        paramDict["lon"] = k.emptyString as AnyObject
        
        print(paramDict)
        
        Api.shared.provider_List(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.array_ProviderList = responseData
            } else {
                self.array_ProviderList = []
            }
            self.doctor_TableVw.reloadData()
        }
    }
}

extension UserHomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_ProviderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorDetailCell", for: indexPath) as! DoctorDetailCell
        
        let obj = self.array_ProviderList[indexPath.row]
        cell.lbl_Name.text = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
        cell.lbl_AddressAndUniversity.text = "\(obj.country_name ?? "")\n\(obj.sub_cat_name ?? "") | \(obj.university_name ?? "")"
        cell.lbl_DateTime.text = "\(obj.open_time ?? "") : \(obj.close_time ?? "")"
        
        if Router.BASE_IMAGE_URL != obj.image {
            Utility.setImageWithSDWebImage(obj.image ?? "", cell.profile_Img)
        } else {
            cell.profile_Img.image = R.image.placeholder()
        }
        
        cell.cloBook = {() in
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "DoctorDetailVC") as! DoctorDetailVC
            vc.provider_Id = self.array_ProviderList[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
}
