//
//  AppFlowCoordinator.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 15.11.2021.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: NavigationViewController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: NavigationViewController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let todoListSceneDIContainer = appDIContainer.makeTodoListSceneDIContainer()
        let flow = todoListSceneDIContainer.makeTodoListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
