//
//  TodoItemsStorage.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 11.11.2021.
//

import Foundation

protocol TodoItemsStorage {
    func fetchTodoItems(forDate date: Date, completion: @escaping ([TodoItem]) -> Void) //-> [TodoItem]
    func saveTodoItemModel(todoItem: TodoItem, completion: @escaping () -> Void)
}
