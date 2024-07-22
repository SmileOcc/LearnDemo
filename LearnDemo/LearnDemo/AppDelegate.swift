//
//  AppDelegate.swift
//  LearnDemo
//
//  Created by odd on 5/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("开始----")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        let viewC = ViewController()
        
        
        self.window?.rootViewController = viewC
        self.window?.makeKeyAndVisible()
        
        checkMainThreadBlock()
        return true
    }

    

}

