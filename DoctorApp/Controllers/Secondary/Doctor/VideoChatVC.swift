//
//  VedioChatVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 13/06/24.
//

import UIKit

class VideoChatVC: UIViewController {

    @IBOutlet weak var videoChat_TableVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoChat_TableVw.register(UINib(nibName: "VideoChatCell", bundle: nil), forCellReuseIdentifier: "VideoChatCell")
    }
}

extension VideoChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoChatCell", for: indexPath) as! VideoChatCell
        return cell
    }
}
