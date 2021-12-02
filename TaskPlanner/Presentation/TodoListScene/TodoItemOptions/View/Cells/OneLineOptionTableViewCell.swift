//
//  TodoItemOptionsTableCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 27.10.2021.
//

import UIKit

final class OneLineOptionTableViewCell: TodoItemOptionsTableViewCell {
    
    private var cellBackgroundView: UIView!
    private var editableTextField: UITextField!
    
    private var viewModel: OneLineInputCellViewModel!

    // MARK: - Fill
    
    override func fill(with viewModel: InputCellViewModel) {
        if let viewModel = viewModel as? OneLineInputCellViewModel {
            self.viewModel = viewModel
            editableTextField.placeholder = viewModel.placeHolder
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupBackgroundView()
        setupEditableTextField()
        setConstraints()
    }
}


// MARK: - Set Constraints

extension OneLineOptionTableViewCell {
    
    private func setConstraints() {
        
        self.contentView.addSubview(cellBackgroundView)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: sideOffset),
            cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -sideOffset),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        cellBackgroundView.addSubview(editableTextField)
        NSLayoutConstraint.activate([
            editableTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            editableTextField.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 15),
            editableTextField.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -10)
        ])
    }
}

// MARK: - Cell background

extension OneLineOptionTableViewCell {
    
    private func setupBackgroundView() {
        cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .clear
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Editable Field

extension OneLineOptionTableViewCell {
    
    private func setupEditableTextField() { // TODO: imp
        editableTextField = UITextField(frame: .zero)
        editableTextField.textColor = .black
        editableTextField.translatesAutoresizingMaskIntoConstraints = false
        editableTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        editableTextField.becomeFirstResponder()
    }
    
    @objc private func textDidChange() {
        let value = editableTextField.text ?? ""
        viewModel.text = value
        viewModel.didChange(value)
    }
}


// MARK: - UITableViewCell

extension OneLineOptionTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // ToDo: handle placeholder
        editableTextField.becomeFirstResponder()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
