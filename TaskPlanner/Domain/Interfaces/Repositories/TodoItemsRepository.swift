//
//  TodoItemsRepository.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 10.11.2021.
//

import Foundation

protocol TodoItemsRepository {
    
    func fetchTodoItems(forDate: Date, completion: @escaping ([TodoItem]) -> Void)
    
    func saveTodoItem(todoItem: TodoItem, completion: @escaping () -> Void)
}
