//
//  TodoItemCellDelegate.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 02.12.2021.
//

import Foundation

protocol TodoItemCellDelegate {
    
    func itemTapped(viewModel: TodoListCardItemViewModel)
}
