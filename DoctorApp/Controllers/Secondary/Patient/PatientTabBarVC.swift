//
//  PatientTabBarVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 15/06/24.
//

import UIKit

class PatientTabBarVC: UITabBarController {
    
    let type = k.userDefault.value(forKey: k.session.type) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundEffect = .none
            tabBarAppearance.shadowColor = .clear
            tabBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.7725490196, blue: 0.4509803922, alpha: 0.5)
            tabBar.standardAppearance = tabBarAppearance
            
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppearance
            }
        } else {
            // Fallback for earlier iOS versions
            tabBar.barTintColor = UIColor.white
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
        
        updateTabBarTitles()
    }
    
    private func updateTabBarTitles() {
        // Assuming tab at index 1 is the one you want to update
        if let viewControllers = self.viewControllers {
            let vC0 = viewControllers[0]
            let vC1 = viewControllers[1]
            let vC2 = viewControllers[2]
            let vC3 = viewControllers[3]
            
            // Check the current language and update the title accordingly
            vC0.tabBarItem.image = R.image.ic_outlineHome()
            vC0.tabBarItem.title = "Home"
            vC1.tabBarItem.image = R.image.tabler_brandBooking()
            vC1.tabBarItem.title = "Booking"
            vC2.tabBarItem.image = R.image.chat28()
            vC2.tabBarItem.title = "Chat"
            vC3.tabBarItem.image = R.image.iconamoon_profileBold()
            vC3.tabBarItem.title = "Profile"
        }
    }
}
