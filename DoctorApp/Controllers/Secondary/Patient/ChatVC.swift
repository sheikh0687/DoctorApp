//
//  UserChatVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var chat_TableVw: UITableView!
    
    var array_LastChat: [Res_LastChat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chat_TableVw.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        last_Message()
    }
}

extension ChatVC {
    
    func last_Message()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["receiver_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        
        print(paramDict)
        
        Api.shared.last_Conversation(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.array_LastChat = responseData
            } else {
                self.array_LastChat = []
            }
            self.chat_TableVw.reloadData()
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_LastChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let obj = self.array_LastChat[indexPath.row]
        cell.lbl_Name.text = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
        cell.lbl_Message.text = obj.last_message ?? ""
        cell.lbl_Date.text = obj.date_time ?? ""
        
        if Router.BASE_IMAGE_URL != obj.image {
            Utility.setImageWithSDWebImage(obj.image ?? "", cell.profile_Img)
        } else {
            cell.profile_Img.image = R.image.placeholder()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ConversationVC") as! ConversationVC
        vc.request_Id = self.array_LastChat[indexPath.row].request_id
        vc.receiver_Id = self.array_LastChat[indexPath.row].receiver_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
