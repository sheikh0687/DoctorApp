//
//  DegreeCell.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 23/07/24.
//

import UIKit

class DegreeCell: UITableViewCell {

    @IBOutlet weak var main_Vw: UIView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var sub_Vw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
