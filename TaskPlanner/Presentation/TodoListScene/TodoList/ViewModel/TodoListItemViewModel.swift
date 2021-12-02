//
//  TodoListItemViewModel.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 10.11.2021.
//

import Foundation
import UIKit

protocol TodoListItemViewModel { }

struct TodoListCardItemViewModel : TodoListItemViewModel  {
    let title: String
    let timeRange: String
    let startHour: Int
    let color: UIColor
    let descriprion: String
}

struct TodoListHourItemViewModel : TodoListItemViewModel  {
    let hourLabel: String
    let hour: Int
}

extension TodoListCardItemViewModel {
    
    init(todoItem: TodoItem) {
        self.title = todoItem.title
        self.timeRange = getTimeRangeString(from: todoItem.startDate, to: todoItem.finishDate)
        self.startHour = getHourNumber(date: todoItem.startDate)
        self.color = todoItem.color.getUIColor()
        self.descriprion = todoItem.description
    }
}


extension TodoListHourItemViewModel {
    
    init(hour: Int) {
        self.hourLabel = getHourString(for: hour)
        self.hour = hour
    }
}


private func getTimeRangeString(from startDate: Date, to finishDate: Date) -> String {
    
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "ru_RU")
    
    let startHour = calendar.component(.hour, from: startDate)
    var startHourString = String(startHour)
    if startHour >= 0 && startHour <= 9 {
        startHourString = "0\(startHourString)"
    }
    if startHourString == "0" { // TODO: [?]
        startHourString = "00"
    }
    
    let startMinute = calendar.component(.minute, from: startDate)
    var startMinutesString = String(calendar.component(.minute, from: startDate))
    if startMinute >= 0 && startMinute <= 9 {
        startMinutesString = "0\(startMinutesString)"
    }
    
    let startTimeString = "\(startHourString):\(startMinutesString)"
    
    let finishHour = calendar.component(.hour, from: finishDate)
    var finishHourString = String(finishHour)
    if finishHour >= 0 && finishHour <= 9 {
        finishHourString = "0\(finishHourString)"
    }
    if finishHourString == "0" {
        finishHourString = "00"
    }
    
    let finishMinute = calendar.component(.minute, from: finishDate)
    var finishMinutesString = String(calendar.component(.minute, from: finishDate))
    if finishMinute >= 0 && finishMinute <= 9 {
        finishMinutesString = "0\(finishMinutesString)"
    }
    
    var finishTimeString = "\(finishHourString):\(finishMinutesString)"
    
    var finishDC = DateComponents()
    finishDC.year = calendar.component(.year, from: finishDate)
    finishDC.month = calendar.component(.month, from: finishDate)
    finishDC.day = calendar.component(.day, from: finishDate)
    finishDC.weekday = calendar.component(.weekday, from: finishDate)
    
    var startDC = DateComponents()
    startDC.year = calendar.component(.year, from: startDate)
    startDC.month = calendar.component(.month, from: startDate)
    startDC.day = calendar.component(.day, from: startDate)

    let finishMidnight = calendar.date(from: finishDC)
    let startMidnight = calendar.date(from: startDC)
    
    if startMidnight != finishMidnight {
        let finishDay = String(calendar.component(.day, from: finishDate))
        var finishWeekDay = ""
        if let finishWeekDayNumber = finishDC.weekday {
            finishWeekDay = calendar.weekdaySymbols[finishWeekDayNumber-1]
        }
        var finishMonth = ""
        if let finishMonthNumber = finishDC.month {
            finishMonth = calendar.monthSymbols[finishMonthNumber-1]
        }
        var finishYearStringWithSpaces = ""
        if calendar.component(.year, from: startDate) != calendar.component(.year, from: finishDate) {
            finishYearStringWithSpaces = " \(String(calendar.component(.year, from: finishDate)))"
        }
        
        finishTimeString = "\(finishDay) \(finishMonth)\(finishYearStringWithSpaces), \(finishTimeString), \(finishWeekDay) "
    }
    
    return "\(startTimeString) - \(finishTimeString)"
}

private func getHourString(for hour: Int) -> String {
    
    var hourString = String(hour)
    
    if hour >= 0 && hour <= 9 {
        hourString = "0\(hourString)"
    }
    if hour == 24 {
        hourString = "00"
    }
    
    return hourString + ":00"
}

private func getHourNumber(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.hour, from: date)
}
