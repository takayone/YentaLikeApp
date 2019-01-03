//
//  MainTabBarController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if Auth.auth().currentUser == nil{
//            let registrationController = RegistrationController()
//            let navController = UINavigationController(rootViewController: registrationController)
//            present(navController, animated: true)
//        }
        if Auth.auth().currentUser == nil{

            DispatchQueue.main.async {
                let registrationController = RegistrationController()
                let navController = UINavigationController(rootViewController: registrationController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupControllers()
    }
    
    fileprivate func setupControllers(){
        
        let swipeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: SwipeController())
        let matchingController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        let reportController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: ReportController())
        let settingsController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: SettingsController())
        
        viewControllers = [swipeController, matchingController, reportController, settingsController]
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
}
