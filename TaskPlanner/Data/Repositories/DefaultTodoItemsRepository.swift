//
//  DefaultTodoItemsRepository.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 11.11.2021.
//

import Foundation

final class DefaultTodoItemsRepository {
    
    private let todoItemsPersistentStorage: TodoItemsStorage
    
    init(todoItemsPersistentStorage: TodoItemsStorage) {
        self.todoItemsPersistentStorage = todoItemsPersistentStorage
    }
}

extension DefaultTodoItemsRepository: TodoItemsRepository {
    
    func fetchTodoItems(forDate: Date, completion: @escaping ([TodoItem]) -> Void) {
        todoItemsPersistentStorage.fetchTodoItems(forDate: forDate, completion: completion)
    }
    
    func saveTodoItem(todoItem: TodoItem, completion: @escaping () -> Void) {
        todoItemsPersistentStorage.saveTodoItemModel(todoItem: todoItem, completion: completion)
    }
}
