//
//  TodoItem.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 27.10.2021.
//

import Foundation
import UIKit

enum TodoItemColor : Int {
    case blue = 1
    case red = 2
    case green = 3
    case yellow = 4
    
    func getUIColor() -> UIColor {
        switch self {
        case .blue:
            return .systemBlue
        case .red:
            return .systemRed
        case .green:
            return .systemGreen
        case .yellow:
            return .systemYellow
        }
    }
}

final class TodoItem {
    
    init(title: String, description: String, startDate: Date, finishDate: Date, allDay: Bool, color: TodoItemColor) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.finishDate = finishDate
        self.allDay = allDay
        self.color = color
    }
    
    init() {
        self.title = ""
        self.description = ""
        self.startDate = Date()
        self.finishDate = Date(timeIntervalSinceNow: 3600)
        self.allDay = false
        self.color = .blue
    }
    
    var title: String = "" {
        didSet {
            print("Title changed: \(title)")
        }
    }
    
    var description: String = "" {
        didSet {
            print("Description changed: \(description)")
        }
    }
    
    var startDate: Date {
        didSet {
            print("Start date changed: \(startDate)")
        }
    }
    
    var finishDate: Date {
        didSet {
            print("Finish date changed: \(finishDate)")
        }
    }
    
    var allDay: Bool {
        didSet {
            print("All-day flag changed: \(allDay)")
        }
    }

    var color: TodoItemColor {
        didSet {
            print("Finish date changed: \(String(describing: color))")
        }
    }
    
    func getStartHour() -> Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: startDate)
    }
}
