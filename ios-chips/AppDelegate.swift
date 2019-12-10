//
//  AppDelegate.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//  Copyright © 2019 DU. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var shared = UIApplication.shared.delegate as? AppDelegate
    var baseTabbar = BaseTabbar()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor  = UIColor.white
        baseTabbar.loadViewController()
        window?.rootViewController = baseTabbar
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

