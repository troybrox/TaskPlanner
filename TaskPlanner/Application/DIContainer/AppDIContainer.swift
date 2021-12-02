//
//  AppDIContainer.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 15.11.2021.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - DIContainers of scenes
    
    func makeTodoListSceneDIContainer() -> TodoListSceneDIContainer {
        return TodoListSceneDIContainer()
    }
}
