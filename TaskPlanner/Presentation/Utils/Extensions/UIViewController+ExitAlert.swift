//
//  UIViewController+ExitAlert.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 08.11.2021.
//

import UIKit

extension UIViewController {
    
    func exitAlert(completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Отменить добавление дела", message: "Введённые данные не сохранятся", preferredStyle: .alert)
        
        let exitAction = UIAlertAction(title: "Выйти", style: .destructive) { (action) in
            completionHandler()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(exitAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
