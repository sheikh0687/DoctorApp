//
//  DoctorDetailCell.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 14/06/24.
//

import UIKit

class DoctorDetailCell: UITableViewCell {

    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_AddressAndUniversity: UILabel!
    @IBOutlet weak var btn_RatingOt: UIButton!
    @IBOutlet weak var lbl_DateTime: UILabel!
    
    var cloBook:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_BookAppointment(_ sender: UIButton) {
        self.cloBook?()
    }
}
