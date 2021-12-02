//
//  TodoListFlowCoordinator.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 06.11.2021.
//

import UIKit

protocol TodoListFlowCoordinatorDependencies {
    func makeTodoListViewController(closures: TodoListViewModelClosures) -> TodoListViewController
    func makeTodoItemDetailsViewController(todoItem: TodoItem) -> UIViewController
    func makeTodoItemTableViewController(closures: TodoItemOptionsViewModelClosures, date: Date) -> TodoItemTableViewController
}

final class TodoListFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: TodoListFlowCoordinatorDependencies
    
    private weak var todoListViewController: TodoListViewController?
    
    init(navigationController: UINavigationController,
         dependencies: TodoListFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let closures = TodoListViewModelClosures(showTodoItemDetails: showTodoItemDetails, showTodoItemOptions: showTodoItemOptions)
        
        let vc = dependencies.makeTodoListViewController(closures: closures)
        navigationController?.pushViewController(vc, animated: true)
        todoListViewController = vc
    }
    
    private func showTodoItemDetails(todoItem: TodoItem) {
        let vc = dependencies.makeTodoItemDetailsViewController(todoItem: todoItem)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showTodoItemOptions(date: Date) {
        let closures = TodoItemOptionsViewModelClosures(cancel: cancelSaving, saveTodoItem: saveAndReturn)
        
        let vc = dependencies.makeTodoItemTableViewController(closures: closures, date: date)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func saveAndReturn(todoItem: TodoItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func cancelSaving() {
        navigationController?.popViewController(animated: true)
    }
}
