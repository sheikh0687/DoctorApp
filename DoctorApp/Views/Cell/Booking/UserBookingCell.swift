//
//  UserBookingCell.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 15/06/24.
//

import UIKit

class UserBookingCell: UITableViewCell {
    
    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_CancerType: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_RefrenceCode: UILabel!
    @IBOutlet weak var btn_GiveRatingView: UIView!
    
    var clo_GiveRating:(() -> Void)?
    var clo_SeeReport:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func btn_GiveRating(_ sender: UIButton) {
        self.clo_GiveRating?()
    }
    
    @IBAction func btn_SeeReport(_ sender: UIButton) {
        self.clo_SeeReport?()
    }
}
