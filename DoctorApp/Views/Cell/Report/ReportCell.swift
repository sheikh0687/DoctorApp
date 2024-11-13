//
//  ReportCell.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 30/07/24.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak var lbl_ReportName: UILabel!
    
    var cloView:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btn_View(_ sender: UIButton) {
        self.cloView?()
    }
}
