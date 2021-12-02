//
//  InputCellViewModel.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 17.11.2021.
//

import Foundation

protocol InputCellViewModel {
//    func isOneLineInputItem() -> Bool
}

extension InputCellViewModel {
    
    func isOneLineInputItem() -> Bool {
        (self as? OneLineInputCellViewModel) != nil
    }
    
    func isMultiLineInputItem() -> Bool {
        (self as? MultiLineInputCellViewModel) != nil
    }
    
    func isDateInputItem() -> Bool {
        (self as? DateInputCellViewModel) != nil
    }
    
    func isColorInputItem() -> Bool {
        (self as? ColorInputCellViewModel) != nil
    }
    
    func isAllDayInputItem() -> Bool {
        (self as? AllDayInputCellViewModel) != nil
    }
}



struct InputSectionViewModel {
    var inputRows: [InputCellViewModel]
}

struct InputSection {
    var rows: [Observable<InputCellViewModel>]
}


enum DateTimeInputType {
    
    case start
    case finish
    
    func getTitle() -> String {
        switch self {
        case .start:
            return "Начало"
        case .finish:
            return "Окончание"
        }
    }
}


struct OneLineInputCellViewModel : InputCellViewModel {
    var text: String
    let placeHolder: String = "Введите название"
    let didChange: (String) -> Void
}

struct MultiLineInputCellViewModel : InputCellViewModel {
    var text: String
    let placeHolder: String = "Введите описание"
    let didChange: (String) -> Void
}

struct DateInputCellViewModel : InputCellViewModel {
    
    let type: DateTimeInputType
    var date: Date
    let didChange: (Date) -> Void
    
    var numberOfWeekday: Int? {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.weekday], from: date)
        guard let weekday = component.weekday else { return nil }
        return weekday
    }
    
    var title: String {
        switch type {
        case .start:
            return "Начало"
        case .finish:
            return "Окончание"
        }
    }
}

struct AllDayInputCellViewModel : InputCellViewModel {
    let title: String = "Весь день"
    var value: Bool
}

struct ColorInputCellViewModel : InputCellViewModel {
    let title: String = "Цвет"
    var color: TodoItemColor
    let didChange: (TodoItemColor) -> Void
}
