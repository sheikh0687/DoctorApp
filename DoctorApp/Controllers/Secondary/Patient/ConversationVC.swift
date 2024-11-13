//
//  ConversationVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit
import ZegoUIKitPrebuiltCall

class ConversationVC: UIViewController {
    
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var txt_Msg: UITextView!
    @IBOutlet weak var lbl_Name: UILabel!
    
    var userName:String = ""
    var receiver_Id:String!
    var request_Id:String!
    
    var refreshControl = UIRefreshControl()
    var image:UIImage?
    
    let userIdd = k.userDefault.value(forKey: k.session.userId) as! String
    let selfUserID: String = String(format: "%d", Int.random(in: 0...99999))
    var selfUserName: String?
    let yourAppID: UInt32 = 1044302740
    let yourAppSign: String = "f59640b18dd6b210f357a97b5cf06bbe6badaa22207e672915b4ba389dc532f1"
    
    var arrayMessages: [Res_ChatDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_Name.text = self.userName
        if #available(iOS 10.0, *) {
            self.tbleView.refreshControl = refreshControl
        } else {
            self.tbleView.addSubview(refreshControl)
        }
        DispatchQueue.main.async {
            self.refreshControl.addTarget(self, action: #selector(self.getChat), for: .valueChanged)
        }
        self.getChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_VideoChat(_ sender: UIButton) {
        let config: ZegoUIKitPrebuiltCallConfig = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        let callVC = ZegoUIKitPrebuiltCallVC.init(yourAppID, appSign: yourAppSign, userID: selfUserID, userName: self.selfUserName ?? "", callID: "100", config: config)
        callVC.modalPresentationStyle = .fullScreen
        self.present(callVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image = image
            self.txt_Msg.text = ""
            self.sendChat()
        }
    }
    
    @IBAction func actionSend(_ sender: Any) {
        if txt_Msg.text == "Write here" || txt_Msg.text.count == 0 {
            self.alert(alertmessage: "Please enter message")
        } else {
            self.sendChat()
        }
    }
}

extension ConversationVC {
    
    @objc func getChat()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["receiver_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["sender_id"] = receiver_Id as AnyObject
        paramDict["request_id"] = request_Id as AnyObject
        paramDict["type"] = "Normal" as AnyObject
        
        print(paramDict)
        
        Api.shared.conversation_Detail(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.arrayMessages = responseData
            } else {
                self.arrayMessages = []
            }
            self.tbleView.reloadData {
                self.refreshControl.endRefreshing()
                self.scrollToBottom()
            }
        }
    }
    
    func sendChat()
    {
        var paramDict: [String : String] = [:]
        paramDict["receiver_id"] = self.receiver_Id
        paramDict["sender_id"] = k.userDefault.value(forKey: k.session.userId) as? String
        paramDict["request_id"] = request_Id
        paramDict["type"] = "Normal"
        paramDict["chat_message"] = txt_Msg.text
        paramDict["timezone"] = localTimeZoneIdentifier
        paramDict["date_time"] = CURRENT_TIME
        
        print(paramDict)
        
        var paramImgDict: [String : UIImage] = [:]
        paramImgDict["chat_image"] = self.image
        
        print(paramImgDict)
        
        Api.shared.sendChat(self, paramDict, images: paramImgDict, videos: [:]) { responseData in
            self.txt_Msg.text = ""
            self.view.endEditing(true)
            self.getChat()
        }
    }
}

extension ConversationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = self.arrayMessages[indexPath.row]
        let strDate = obj.date_time ?? ""
        
        if let imageUrl = obj.chat_image, imageUrl != Router.BASE_IMAGE_URL {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageCell", for: indexPath) as! ChatImageCell
            cell.imgLeft.isHidden = true
            cell.imgLeft.isHidden = true
            if let senderId = obj.sender_id, self.userIdd == senderId {
                cell.imgRight.isHidden = false
                Utility.setImageWithSDWebImage(obj.chat_image ?? "", cell.imgRight)
            } else {
                cell.imgLeft.isHidden = false
                Utility.setImageWithSDWebImage(obj.chat_image ?? "", cell.imgLeft)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as!
            ConversationCell
            cell.chatRight.isHidden = true
            cell.chatLeft.isHidden = true
            
            if strDate != "0000-00-00 00:00:00" {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = formatter.date(from: strDate)
                formatter.dateFormat = "dd MMM yyyy hh:mm a"
                cell.lblDate.text = formatter.string(from: date!)
            } else {
                cell.lblDate.text = ""
            }
            
            if let senderId = obj.sender_id, self.userIdd == senderId {
                cell.chatRight.cornerRadius = cell.chatRight.frame.height / 2
                cell.chatRight.clipsToBounds = true
                cell.chatRight.isHidden = false
                cell.lblMsgRight.text = obj.chat_message ?? ""
                cell.lblDate.textAlignment = .right
            } else {
                cell.chatLeft.cornerRadius = cell.chatRight.frame.height / 2
                cell.chatLeft.clipsToBounds = true
                cell.chatLeft.isHidden = false
                cell.lblMsgLeft.text = obj.chat_message ?? ""
                cell.lblDate.textAlignment = .left
            }
            
            return cell
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.arrayMessages.count > 0 {
                let indexPath = IndexPath(row: self.arrayMessages.count-1, section: 0)
                self.tbleView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}
