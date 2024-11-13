//
//  DoctorDetailsVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 14/06/24.
//

import UIKit

class DoctorInfoVC: UIViewController {

    @IBOutlet weak var searchVw: UISearchBar!
    @IBOutlet weak var doctor_TableVw: UITableView!
    
    var array_AllProviderList: [Res_ProviderList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctor_TableVw.register(UINib(nibName: "DoctorDetailCell", bundle: nil), forCellReuseIdentifier: "DoctorDetailCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension DoctorInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_AllProviderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorDetailCell", for: indexPath) as! DoctorDetailCell
        let obj = self.array_AllProviderList[indexPath.row]
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
            vc.provider_Id = self.array_AllProviderList[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
}
