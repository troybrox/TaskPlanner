//
//  TodoListSceneDIContainer.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 15.11.2021.
//

import Foundation
import UIKit

final class TodoListSceneDIContainer {
    
    // MARK: - Persistant Sorage
    
    lazy var todoItemStorage: TodoItemsStorage = RealmTodoItemsStorage(maxStorageLimit: 1000000)
    
    init() { }
    
    // MARK: - Use Cases
    
    func makeFetchTodoItemsUseCase() -> FetchTodoItemsUseCase {
        return FetchTodoItemsUseCase(todoItemsRepository: makeTodoitemsRepository())
    }
    
    func makeAddTodoItemUseCase() -> AddTodoItemUseCase {
        return AddTodoItemUseCase(todoItemsRepository: makeTodoitemsRepository())
    }
    
    
    // MARK: - Repositories
    
    func makeTodoitemsRepository() -> TodoItemsRepository {
        return DefaultTodoItemsRepository(todoItemsPersistentStorage: todoItemStorage)
    }
    
    
    // MARK: - Todo List
    
    func makeTodoListViewController(closures: TodoListViewModelClosures) -> TodoListViewController {
        return TodoListViewController.create(with: makeTodoListViewModel(actions: closures))
    }
    
    func makeTodoListViewModel(actions: TodoListViewModelClosures) -> TodoListViewModel {
        return DefaultTodoListViewModel(fetchTodoItemsUseCase: makeFetchTodoItemsUseCase(),
                                        actions: actions)
    }

    // MARK: - Todo Item Options

    func makeTodoItemTableViewController(closures: TodoItemOptionsViewModelClosures, date: Date) -> TodoItemTableViewController {
        return TodoItemTableViewController.create(with: makeTodoItemOptionsViewModel(closures: closures, date: date))
    }
    
    func makeTodoItemOptionsViewModel(closures: TodoItemOptionsViewModelClosures, date: Date) -> TodoItemOptionsViewModel {
        return DefaultTodoItemOptionsViewModel(todoItem: TodoItem(), addTodoItemUseCase: makeAddTodoItemUseCase(), date: date, closures: closures)
    }
    
    // MARK: - Todo Item Details
    
    func makeTodoItemDetailsViewController(todoItem: TodoItem) -> UIViewController {
        return UIViewController()
    }
    
    
    // MARK: - Flow Coordinators
    
    func makeTodoListFlowCoordinator(navigationController: UINavigationController) -> TodoListFlowCoordinator {
        return TodoListFlowCoordinator(navigationController: navigationController,
                                          dependencies: self)
    }
}

extension TodoListSceneDIContainer : TodoListFlowCoordinatorDependencies { }
