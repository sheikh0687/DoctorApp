//
//  AppointmentCell.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 13/06/24.
//

import UIKit

class AppointmentCell: UITableViewCell {

    @IBOutlet weak var user_Img: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UniqueCode: UILabel!
    @IBOutlet weak var lbl_Age: UILabel!
    @IBOutlet weak var lbl_Desease: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_UserCountryName: UILabel!
    @IBOutlet weak var btn_AcceptOt: UIButton!
    
    var cloAccept:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_Accept(_ sender: UIButton) {
        self.cloAccept?()
    }
    
}
