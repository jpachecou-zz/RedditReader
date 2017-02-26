//
//  ApiCong.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

struct ApiCong {
    
    static func startFlowApp() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        appDelegate.window = window
        appDelegate.navigationController = navigationController
        // Launch Start Operation
        let vc: HomeViewController = DI.Home.resolveDependency()!
        navigationController.pushViewController(vc, animated: true)
        
        let launchScreen: SplashViewController = DI.Splash.resolveDependency()!
        launchScreen.do {
            window.addSubview($0.view)
            $0.view.frame = UIScreen.main.bounds
            $0.splashAnimation()
        }
    }
    
    static func appearanceConfig() {
        IQKeyboardManager.sharedManager().enable = true
        
        UINavigationBar.appearance().do {
            $0.titleTextAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight),
                NSForegroundColorAttributeName: UIColor.white
            ]
            $0.barTintColor = .main
            $0.tintColor = .white
            $0.isTranslucent = true
        }
        
        UIToolbar.appearance().do {
            $0.barTintColor = .main
            $0.tintColor = .white
            $0.isTranslucent = true
        }
    }
}
