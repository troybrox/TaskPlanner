//
//  TodoItemEntity+Mapping.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 11.11.2021.
//

import Foundation

extension TodoItemEntity {
    
    convenience init(todoItem: TodoItem) {
        self.init()
        title = todoItem.title
        itemDescription = todoItem.description
        startDate = todoItem.startDate
        finishDate = todoItem.finishDate
        color = todoItem.color.rawValue
    }
}

extension TodoItemEntity {
    
    func toDomain() -> TodoItem {
        return .init(title: title,
                     description: itemDescription,
                     startDate: startDate,
                     finishDate: finishDate,
                     allDay: false,
                     color: TodoItemColor(rawValue: color) ?? .blue)
    }
}
