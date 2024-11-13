//
//  WeeklyScheduleVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 23/07/24.
//

import UIKit

class WeeklyScheduleVC: UIViewController {
    
    @IBOutlet weak var schedule_TableVw: UITableView!
    @IBOutlet weak var schedule_TableHeight: NSLayoutConstraint!
    
    var array_WeekSchedule: [Provider_time_details] = []
    
    var res_OpenTime: [String] = []
    var res_CloseTime: [String] = []
    var res_DayNames: [String] = []
    var res_OpenCloseStatus: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schedule_TableVw.register(UINib(nibName: "WeeklyScheduleCell", bundle: nil), forCellReuseIdentifier: "WeeklyScheduleCell")
        providerDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Set Weekly Availability", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_Add(_ sender: UIButton) {
        ProviderTimeSchedule()
    }
}

extension WeeklyScheduleVC {
    
    func providerDetails()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["provider_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject
        
        print(paramDict)
        
        Api.shared.provider_Info(self, paramDict) { responseData in
            if let obj = responseData.provider_time_details {
                if obj.count > 0 {
                    self.array_WeekSchedule = obj
                    self.schedule_TableHeight.constant = CGFloat(self.array_WeekSchedule.count * 60)
                } else {
                    self.array_WeekSchedule = []
                }
                self.schedule_TableVw.reloadData()
            }
        }
    }
    
    func ProviderTimeSchedule()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["provider_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["authorization_token"] = k.emptyString as AnyObject
        paramDict["open_day"] = res_DayNames.joined(separator: ",") as AnyObject
        paramDict["open_time"] = res_OpenTime.joined(separator: ",") as AnyObject
        paramDict["close_time"] = res_CloseTime.joined(separator: ",") as AnyObject
        paramDict["open_close_status"] = res_OpenCloseStatus.joined(separator: ",") as AnyObject
        
        print(paramDict)
        
        Api.shared.provider_AddTime(self, paramDict) { responseData in
            if responseData.status == "1" {
                Utility.showAlertWithAction(withTitle: k.appName, message: "Profile updated successfully", delegate: nil, parentViewController: self) { bool in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension WeeklyScheduleVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_WeekSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyScheduleCell", for: indexPath) as! WeeklyScheduleCell
        
        let obj = self.array_WeekSchedule[indexPath.row]
        
        switch obj.open_day {
        case "Monday":
            cell.lbl_Day.text = "Monday".localiz()
        case "Tuesday":
            cell.lbl_Day.text = "Tuesday".localiz()
        case "Wednesday":
            cell.lbl_Day.text = "Wednesday".localiz()
        case "Thursday":
            cell.lbl_Day.text = "Thursday".localiz()
        case "Friday":
            cell.lbl_Day.text = "Friday".localiz()
        case "Saturday":
            cell.lbl_Day.text = "Saturday".localiz()
        default:
            cell.lbl_Day.text = "Sunday".localiz()
        }
        
        cell.btn_OpenTimeOt.setTitle(obj.open_time ?? "", for: .normal)
        cell.btn_CloseTimeOt.setTitle(obj.close_time ?? "", for: .normal)
        
        if obj.open_close_status == "OPEN" {
            cell.btn_OpenCloseSt.setImage(R.image.rectangleCheckedYellow(), for: .normal)
        } else {
            cell.btn_OpenCloseSt.setImage(R.image.rectangleUncheckYellow(), for: .normal)
        }
        
        let resOpenCloseStatus = array_WeekSchedule.map({$0.open_close_status ?? ""})
        self.res_OpenCloseStatus = resOpenCloseStatus
        
        let resOpenTime = array_WeekSchedule.map({$0.open_time ?? ""})
        self.res_OpenTime = resOpenTime
        
        let resCloseTime = array_WeekSchedule.map({$0.close_time ?? ""})
        self.res_CloseTime = resCloseTime
        
        let resDayName = array_WeekSchedule.map({$0.open_day ?? ""})
        self.res_DayNames = resDayName
        
        cell.cloOpenCloseStatus = {(statuss) in
            self.res_OpenCloseStatus[indexPath.row] = statuss
        }
        
        cell.cloOpenTime = {() in
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "PresentTimeScheduleVC") as! PresentTimeScheduleVC
            vc.cloTimeSlot = {(time) in
                cell.btn_OpenTimeOt.setTitle(time, for: .normal)
                self.res_OpenTime[indexPath.row] = time
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        cell.cloCloseTime = {() in
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "PresentTimeScheduleVC") as! PresentTimeScheduleVC
            vc.cloTimeSlot = {(time) in
                cell.btn_CloseTimeOt.setTitle(time, for: .normal)
                self.res_CloseTime[indexPath.row] = time
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
