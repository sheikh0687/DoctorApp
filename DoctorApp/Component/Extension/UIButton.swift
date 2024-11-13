//
//  UIButton.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 11/11/24.
//

import Foundation

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
