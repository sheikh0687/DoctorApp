//
//  QualificationVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 22/07/24.
//

import UIKit
import UniformTypeIdentifiers

class QualificationVC: UIViewController {

    @IBOutlet weak var txt_Degree: UITextField!
    @IBOutlet weak var degrees_TableVw: UITableView!
    @IBOutlet weak var lbl_DegreeText: UILabel!
    @IBOutlet weak var btn_AddOt: UIButton!
    
    var Docs: Data?
    var array_Documents: [Res_DegreeList] = []
    
    var isComing:String = ""
    var array_Reports: [Res_UserReports] = []
    
    let type = k.userDefault.value(forKey: k.session.type) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        degrees_TableVw.register(UINib(nibName: "DegreeCell", bundle: nil), forCellReuseIdentifier: "DegreeCell")
        degrees_TableVw.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        if type == "USER" {
            self.lbl_DegreeText.text = "My previous reports"
            self.txt_Degree.placeholder = "Enter report name"
            setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Upload Reports", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
            fetchUserReports()
        } else {
            self.lbl_DegreeText.text = "My Degree's"
            self.txt_Degree.placeholder = "Enter Degree name"
            setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Add Your Degree", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
            GetAllDegrees()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_UploadDegree(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func btn_AddDegree(_ sender: UIButton) {
        if type == "USER" {
            if txt_Degree.text?.count == 0 {
                self.alert(alertmessage: "Please enter the report Name")
            } else if (Docs == nil) {
                self.alert(alertmessage: "Please attach report")
            } else {
                addReport()
            }
        } else {
            if txt_Degree.text?.count == 0 {
                self.alert(alertmessage: "Please enter the Degree Name")
            } else if (Docs == nil) {
                self.alert(alertmessage: "Please attach Degree")
            } else {
                add_Degrees()
            }
        }
    }
}

extension QualificationVC {
    
    func add_Degrees()
    {
        var param: [String : String] = [:]
        param["user_id"] = k.userDefault.value(forKey: k.session.userId) as? String
        param["name"] = txt_Degree.text
        
        print(param)
        
        var paramDocs: [String : Data] = [:]
        paramDocs["degree_file"] = Docs
        
        print(paramDocs)
        
        Api.shared.upload_DoctorDegree(self, param, images: paramDocs, videos: [:], { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Your degree uploaded successfully", delegate: nil, parentViewController: self) { bool in
                self.GetAllDegrees()
                self.dismiss(animated: true)
            }
        })
    }
    
    func GetAllDegrees()
    {
        Api.shared.doctor_DegreeList(self) { responseData in
            if responseData.count > 0 {
                self.array_Documents = responseData
            } else {
                self.array_Documents = []
            }
            self.degrees_TableVw.reloadData()
        }
    }
    
    func addReport()
    {
        var paramDict: [String : String] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as? String
        paramDict["name"] = txt_Degree.text
        
        print(paramDict)
        
        var paramDocs: [String : Data] = [:]
        paramDocs["report_file"] = Docs
        
        print(paramDocs)
        
        Api.shared.requestToUploadUserReport(self, paramDict, images: paramDocs, videos: [:]) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Your report uploaded successfully", delegate: nil, parentViewController: self) { bool in
                self.fetchUserReports()
                self.dismiss(animated: true)
            }

        }
    }
    
    func fetchUserReports()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        
        Api.shared.requestToUserReports(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.array_Reports = responseData
            } else {
                self.array_Reports = []
            }
            self.degrees_TableVw.reloadData()
        }
    }
}

extension QualificationVC: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let imgUrl = urls.first else {
            return
        }
        print("import result: \(imgUrl)")
        
        let imgData = try? Data(contentsOf: imgUrl)
        self.Docs = imgData
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}

extension QualificationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "USER" {
            return self.array_Reports.count
        } else {
            return self.array_Documents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == "USER" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            let obj = self.array_Reports[indexPath.row]
            cell.lbl_ReportName.text = "\(obj.name ?? "")\n\(obj.date_time ?? "")"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DegreeCell", for: indexPath) as! DegreeCell
            let obj = self.array_Documents[indexPath.row]
            cell.sub_Vw.backgroundColor = .clear
            cell.main_Vw.backgroundColor = .systemGray6
            cell.main_Vw.cornerRadius1 = 10
            cell.main_Vw.borderWidth1 = 0.5
            cell.main_Vw.borderColor1 = .separator
            cell.lbl_Name.text = obj.name ?? ""
            cell.lbl_Date.text = obj.date_time ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == "USER" {
            return UITableView.automaticDimension
        } else {
            return 80
        }
    }
}
