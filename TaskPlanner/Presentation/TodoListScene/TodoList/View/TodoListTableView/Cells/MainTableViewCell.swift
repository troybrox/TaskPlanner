//
//  MainTableViewCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 31.10.2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    weak var cellTodoItemDelegate: PressViewProtocol?
    
    var index: IndexPath?
    
    func setStyle() { }
    
    func fill(with viewModel: TodoListItemViewModel) {}
}
