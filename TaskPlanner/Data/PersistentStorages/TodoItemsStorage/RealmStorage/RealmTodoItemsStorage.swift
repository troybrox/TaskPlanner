//
//  RealmTodoItemsStorage.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 11.11.2021.
//

import RealmSwift

final class RealmTodoItemsStorage {
    
    private let maxStorageLimit: Int
    
    private let localRealm = try! Realm()
    
    init(maxStorageLimit: Int) {
        self.maxStorageLimit = maxStorageLimit
    }
}

extension RealmTodoItemsStorage : TodoItemsStorage {

    func fetchTodoItems(forDate date: Date, completion: @escaping ([TodoItem]) -> Void) {
        
        let calendar = Calendar.current
        let startPoint = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date, direction: .backward)
        let finishPoint = startPoint?.addingTimeInterval(3600 * 24 - 1)

        let todoItemsForDate = localRealm.objects(TodoItemEntity.self)
            .filter("startDate BETWEEN {%@, %@}", startPoint, finishPoint)
            .sorted(byKeyPath: "startDate")

        let resultArray: [TodoItem] = todoItemsForDate.map { $0.toDomain() }
        completion(resultArray)
    }
    
    func saveTodoItemModel(todoItem: TodoItem, completion: @escaping () -> Void) {
        try! localRealm.write {
            localRealm.add(TodoItemEntity(todoItem: todoItem))
        }
    }
}
