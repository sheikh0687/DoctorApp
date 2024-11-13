//
//  ReportsVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 30/07/24.
//

import UIKit

class ReportsVC: UIViewController {

    @IBOutlet weak var report_TableVw: UITableView!
    var array_Reports: [Res_UserReports] = []
    
    var user_Id:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.report_TableVw.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        fetchUserReports()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Report", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func fetchUserReports()
    {
        var paramDict: [String : AnyObject] = [:]
        if k.userDefault.value(forKey: k.session.type) as! String == "USER" {
            paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject
        } else {
            paramDict["user_id"] = user_Id as AnyObject
        }
        
        Api.shared.requestToUserReports(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.array_Reports = responseData
            } else {
                self.array_Reports = []
            }
            self.report_TableVw.reloadData()
        }
    }
}

extension ReportsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_Reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        let obj = self.array_Reports[indexPath.row]
        cell.lbl_ReportName.text = "\(obj.name ?? "")\n\(obj.date_time ?? "")"
        return cell
    }
}
