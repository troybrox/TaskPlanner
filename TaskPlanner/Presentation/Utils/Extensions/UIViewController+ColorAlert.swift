//
//  UIViewController+ColorAlert.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 30.11.2021.
//

import UIKit

extension UIViewController {
    
    func alertColor(color: TodoItemColor, completion: @escaping (TodoItemColor) -> Void) {
        
        let alert = UIAlertController(title: "Цвет", message: nil, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Ок", style: .default) { (action) in
        }
        
        alert.addAction(okAction)
        
        alert.view.heightAnchor.constraint(equalToConstant: 330).isActive = true
        
        present(alert, animated: true, completion: nil)
    }
}
