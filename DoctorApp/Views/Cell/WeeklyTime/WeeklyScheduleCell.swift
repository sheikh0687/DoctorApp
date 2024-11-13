//
//  WeeklyScheduleCell.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 23/07/24.
//

import UIKit

class WeeklyScheduleCell: UITableViewCell {

    @IBOutlet weak var lbl_Day: UILabel!
    
    @IBOutlet weak var btn_OpenTimeOt: UIButton!
    @IBOutlet weak var btn_CloseTimeOt: UIButton!
    @IBOutlet weak var btn_OpenCloseSt: UIButton!
    
    var cloOpenCloseStatus:((_ status: String) -> Void)?
    var cloOpenTime:(() -> Void)?
    var cloCloseTime:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btn_Check(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(R.image.rectangleUncheckYellow(), for: .normal)
            cloOpenCloseStatus?("CLOSE")
        } else {
            sender.isSelected = true
            sender.setImage(R.image.rectangleCheckedYellow(), for: .normal)
            cloOpenCloseStatus?("OPEN")
        }
    }
    
    @IBAction func btn_OpenTime(_ sender: UIButton) {
        self.cloOpenTime?()
    }
    
    @IBAction func btn_CloseTime(_ sender: UIButton) {
        self.cloCloseTime?()
    }
}
