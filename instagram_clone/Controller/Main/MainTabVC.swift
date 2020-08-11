//
//  MainTabVC.swift
//  instagram_clone
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

/*** Configure UITabBarController Programmatically ***/

import UIKit
import FirebaseAuth

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // delegate
        self.delegate = self
        configureViewControllers()
   
        // user validation
        checkIfUserIsLoggedIn()
    }
    
    // function to create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        // home feed controller, UICollectionViewController이기 때문에 `collectionViewLayout`을 넘겨줘야한다.
        let feedVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // search feed controller, UITableViewController
        let searchVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchVC())
        
        // post controller, UIViewController
        let uploadPostVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: UploadPostVC())
        
        // notification controller, UITableViewController
        let notificationVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationVC())
        
        // profile controller, UICollectionViewController
        let userProfileVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        // view controller to be added to tab controller
        viewControllers = [feedVC, searchVC, uploadPostVC, notificationVC, userProfileVC]
        
        // tabbar tint color
        tabBar.tintColor = .black
        
    }
    
    // construct navigation controllers
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black //default back button, title text color...
        
        //return nav controller
        return navController
    }
    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            print("user not logged in")
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .overCurrentContext
                self.present(navController, animated: false, completion: nil)
            }
        }
        
    }

}
