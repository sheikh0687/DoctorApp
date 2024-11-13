//
//  PaymentMethodCollectionViewCell.swift
//  MFSDKDemo-Swift
//
//  Created by Elsayed Hussein on 8/29/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import UIKit
import MFSDK

class PaymentMethodCollectionViewCell: UICollectionViewCell {
    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var paymentMethodImageView: UIImageView!
    @IBOutlet weak var paymentMethodNameLabel: UILabel!
    
    //MARK Methods
    func configure(paymentMethod: MFPaymentMethod, selected: Bool) {
        paymentMethodImageView.image = nil
        paymentMethodImageView.layer.cornerRadius = 5
        if selected {
            if #available(iOS 13.0, *) {
                paymentMethodImageView.layer.borderColor = UIColor.label.cgColor
            } else {
                paymentMethodImageView.layer.borderColor = UIColor.black.cgColor
            }
            paymentMethodImageView.layer.borderWidth = 3
        } else {
            paymentMethodImageView.layer.borderWidth = 0
        }
        if let imageURL = paymentMethod.imageUrl {
            paymentMethodImageView.downloaded(from: imageURL)
        }
        paymentMethodNameLabel.text = paymentMethod.paymentMethodEn ?? ""
    }
}
