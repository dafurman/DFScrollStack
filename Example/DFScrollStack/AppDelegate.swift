//
//  AppDelegate.swift
//  DFScrollStack
//
//  Created by dafurman on 04/28/2019.
//  Copyright (c) 2019 dafurman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()

        let vc = EntryViewController()
        let navVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = navVC

        return true
    }
}
