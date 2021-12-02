//
//  FetchTodoItemsUseCase.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 11.11.2021.
//

import Foundation

// TODO: add protocol

final class FetchTodoItemsUseCase {
    
    typealias ResultValue = [TodoItem]
    
    private let todoItemsRepository: TodoItemsRepository

    init(todoItemsRepository: TodoItemsRepository) {
        self.todoItemsRepository = todoItemsRepository
    }
    
    
    func start(selectedDate: Date, completion: @escaping ([TodoItem]) -> Void) {
        todoItemsRepository.fetchTodoItems(forDate: selectedDate, completion: completion)
    }
}
