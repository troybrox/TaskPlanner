//
//  UIViewController+DateTimeAlert.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 08.11.2021.
//

import UIKit

extension UIViewController {
    
    func alertDate(button: UIButton, buttonCurrentDate: Date, completionHandler: @escaping (Int, Date) -> Void) {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale.init(identifier: "Ru_ru")
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.date = buttonCurrentDate
        
        alert.view.addSubview(datePicker)
        
        let okAction = UIAlertAction(title: "Ок", style: .default) { (action) in
            
//            let dateTimeFormatter = DateFormatter()
//            dateTimeFormatter.dateFormat = "dd/MM/yyyy HH:mm"
//            let dateTimeString = dateTimeFormatter.string(from: datePicker.date)
            
            let calendar = Calendar.current
            let component = calendar.dateComponents([.weekday], from: datePicker.date)
            guard let weekday = component.weekday else { return }
            
            let numberOfDay = weekday
            let date = datePicker.date
            
            completionHandler(numberOfDay, date)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        alert.view.heightAnchor.constraint(equalToConstant: 330).isActive = true
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 0).isActive = true
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func alertDateTime(currentDate: Date, completion: @escaping (Date) -> Void) {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale.init(identifier: "Ru_ru")
        datePicker.date = currentDate
        
        alert.view.addSubview(datePicker)
        
        let okAction = UIAlertAction(title: "Ок", style: .default) { (action) in
            let date = datePicker.date
            completion(date)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        alert.view.heightAnchor.constraint(equalToConstant: 330).isActive = true
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 0).isActive = true
        
        present(alert, animated: true, completion: nil)
    }
}
