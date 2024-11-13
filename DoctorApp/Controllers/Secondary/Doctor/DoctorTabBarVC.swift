//
//  DoctorTabBarVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 13/06/24.
//

import UIKit

class DoctorTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundEffect = .none
            tabBarAppearance.shadowColor = .clear
            tabBarAppearance.backgroundColor = UIColor.white
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func updateTabBarTitles() {
        // Assuming tab at index 1 is the one you want to update
        if let viewControllers = self.viewControllers {
//            let vC0 = viewControllers[0]
            let vC1 = viewControllers[1]
//            let vC2 = viewControllers[2]
            let vC3 = viewControllers[3]
            
            // Check the current language and update the title accordingly
            vC3.tabBarItem.image = R.image.settingTab()
            vC1.tabBarItem.image = R.image.chat30()
        }
    }
}
