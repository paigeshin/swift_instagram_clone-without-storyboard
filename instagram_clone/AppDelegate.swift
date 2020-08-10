//
//  AppDelegate.swift
//  instagram_clone
//
//  Created by shin seunghyun on 2020/08/10.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //ios 11, LoginVC or setting up project without storyboard
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: LoginVC())
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        return true
    }



}

