//
//  Swicther.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 21/06/24.
//

import Foundation

class Swicther {
    
//    static func updateRootVC()
//    {
//        let status = k.userDefault.bool(forKey: k.session.status)
//        let type = k.userDefault.value(forKey: k.session.type) as! String
//        if status {
//            if type == "USER" {
//                let mainViewController = R.storyboard.main().instantiateViewController(withIdentifier: "PatientTabBarVC") as! PatientTabBarVC
//                let vc = UINavigationController(rootViewController: mainViewController)
//                kAppDelegate.window?.rootViewController = vc
//                kAppDelegate.window?.makeKeyAndVisible()
//            } else {
//                let mainViewController = R.storyboard.main().instantiateViewController(withIdentifier: "DoctorTabBarVC") as! DoctorTabBarVC
//                let vc = UINavigationController(rootViewController: mainViewController)
//                kAppDelegate.window?.rootViewController = vc
//                kAppDelegate.window?.makeKeyAndVisible()
//            }
//        } else {
//            let rootVC = R.storyboard.main().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            let nav = UINavigationController(rootViewController: rootVC)
//            nav.isNavigationBarHidden = false
//            kAppDelegate.window!.rootViewController = nav
//            kAppDelegate.window?.makeKeyAndVisible()
//        }
//    }
    
    class func updateRootVC()
    {
        if k.userDefault.value(forKey: k.session.userId) != nil {
                if let selectedType = k.userDefault.value(forKey: k.session.type)
                {
                    if selectedType as! String == "USER"
                    {
                        let homeVC = R.storyboard.main().instantiateViewController(withIdentifier: "PatientTabBarVC") as! PatientTabBarVC
                        let checkVC = UINavigationController(rootViewController: homeVC)
                        
                        kAppDelegate.window?.rootViewController = checkVC
                        kAppDelegate.window?.makeKeyAndVisible()
                    }
                    else
                    {
                        let homeVC = R.storyboard.main().instantiateViewController(withIdentifier: "DoctorTabBarVC") as! DoctorTabBarVC
                        let checkVC = UINavigationController(rootViewController: homeVC)
                        
                        kAppDelegate.window?.rootViewController = checkVC
                        kAppDelegate.window?.makeKeyAndVisible()
                    }
                }
        } else {
            let mainVC = R.storyboard.main().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let checkVC = UINavigationController(rootViewController: mainVC)
            
            kAppDelegate.window?.rootViewController = checkVC
            kAppDelegate.window?.makeKeyAndVisible()
//            if isLogout {
//                let mainVC = R.storyboard.main().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                let checkVC = UINavigationController(rootViewController: mainVC)
//                
//                kAppDelegate.window?.rootViewController = checkVC
//                kAppDelegate.window?.makeKeyAndVisible()
//            } else {
//                let homeVC = R.storyboard.main().instantiateViewController(withIdentifier: "PatientTabBarVC") as! PatientTabBarVC
//                let checkVC = UINavigationController(rootViewController: homeVC)
//                
//                kAppDelegate.window?.rootViewController = checkVC
//                kAppDelegate.window?.makeKeyAndVisible()
//            }
        }
    }
}
