//
//  AppDelegate.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 25.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationViewController()
        
        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController, appDIContainer: appDIContainer)
        
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        
        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }
}
