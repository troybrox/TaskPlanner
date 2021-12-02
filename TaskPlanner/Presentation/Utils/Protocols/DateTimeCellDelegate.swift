//
//  DateTimeCellDelegate.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 02.12.2021.
//

import Foundation

protocol DateTimeCellDelegate : AnyObject {
    
    func dateTimeButtonChanged(date: Date, cellRow: Int)
    func alertDatePicker(currentDate: Date, dateType: DateTimeInputType)
}
