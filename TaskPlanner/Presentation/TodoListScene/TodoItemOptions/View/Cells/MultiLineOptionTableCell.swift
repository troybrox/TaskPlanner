//
//  TodoItemDescriptionTableCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 29.10.2021.
//

import UIKit

class MultiLineOptionTableCell: TodoItemOptionsTableViewCell{
    
    private var cellBackgroundView: UIView!
    private var editableTextView: UITextView!
    
    private var viewModel: MultiLineInputCellViewModel!
    
    private let placeholderColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1) // systemGray4
    private lazy var placeholderText = ""
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellBackgroundView.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Fill
    
    override func fill(with viewModel: InputCellViewModel) {
        if let viewModel = viewModel as? MultiLineInputCellViewModel {
            self.viewModel = viewModel
            
            placeholderText = viewModel.placeHolder
            
            if !viewModel.text.isEmpty {
                editableTextView.text = viewModel.text
            }
            else {
                editableTextView.text = viewModel.placeHolder
                editableTextView.textColor = placeholderColor
            }
            
            editableTextView.selectedTextRange = editableTextView.textRange(from: editableTextView.beginningOfDocument, to: editableTextView.beginningOfDocument)
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupBackgroundView()
        setupEditableTextView()
        setConstraints()
    }
}


// MARK: - Set Constraints

extension MultiLineOptionTableCell {
    
    func setConstraints() {
        
        self.contentView.addSubview(cellBackgroundView)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: sideOffset),
            cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -sideOffset),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        cellBackgroundView.addSubview(editableTextView)
        NSLayoutConstraint.activate([
            editableTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            editableTextView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 5),
            editableTextView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 5),
            editableTextView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -5),
            editableTextView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - Cell background

extension MultiLineOptionTableCell {
    
    private func setupBackgroundView() {
        cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .clear
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Editable Field

extension MultiLineOptionTableCell {
    
    private func setupEditableTextView() {
        editableTextView = UITextView()
        editableTextView.delegate = self
        editableTextView.isEditable = true
        editableTextView.textColor = .black
        editableTextView.translatesAutoresizingMaskIntoConstraints = false
        editableTextView.font = UIFont.systemFont(ofSize: 17)
        editableTextView.textContainer.lineFragmentPadding = 10.0
    }
}

// MARK: - UITextViewDelegate

extension MultiLineOptionTableCell : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
         else if textView.textColor == placeholderColor && !text.isEmpty {
             textView.textColor = UIColor.black
             textView.text = text
        }

        else {
            return true
        }

        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.textColor == placeholderColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        viewModel.text = editableTextView.text
        viewModel.didChange(editableTextView.text)
    }
}
