//
//  AddTodoItemUseCase.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 23.11.2021.
//

import Foundation

final class AddTodoItemUseCase {
    
    private let todoItemsRepository: TodoItemsRepository

    init(todoItemsRepository: TodoItemsRepository) {
        self.todoItemsRepository = todoItemsRepository
    }
    
    
    func start(todoItem: TodoItem, completion: @escaping () -> Void) {
        todoItemsRepository.saveTodoItem(todoItem: todoItem, completion: completion)
    }
}
