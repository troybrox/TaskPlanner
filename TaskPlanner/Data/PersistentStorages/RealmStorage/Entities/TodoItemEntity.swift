//
//  TodoItemEntity.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 11.11.2021.
//

import RealmSwift

class TodoItemEntity : Object {
    
    @Persisted var id: String = ""
    @Persisted var title: String = ""
    @Persisted var itemDescription: String = ""
    @Persisted var startDate = Date()
    @Persisted var finishDate = Date()
    @Persisted var color: Int = 1
}
