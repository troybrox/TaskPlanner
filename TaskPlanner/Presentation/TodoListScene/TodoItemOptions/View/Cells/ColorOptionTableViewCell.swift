//
//  ColorOptionTableViewCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 01.11.2021.
//

import UIKit

class ColorOptionTableViewCell : TodoItemOptionsTableViewCell {

    private var cellBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cellTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.backgroundColor = .clear
        return label
    }()
    
    private var colorButton: UIButton = {
        let button = UIButton()
        let colorButtonDiameter: CGFloat = 24.0
        button.widthAnchor.constraint(equalToConstant: colorButtonDiameter).isActive = true
        button.heightAnchor.constraint(equalToConstant: colorButtonDiameter).isActive = true
        button.layer.cornerRadius = 0.5 * colorButtonDiameter
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellBackgroundView.layoutIfNeeded()
    }
    
    // MARK: Initializing a Cell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        setConstrints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        changeHandler = { _ in }
    }
    
    // MARK: Managing the Content
    
    override func configure(for model: FormItem) {
        
        if let colorFormItem = model as? ColorInputFormItem {
            cellTitle.text = colorFormItem.title
            colorButton.backgroundColor = colorFormItem.color.getUIColor()
            changeHandler = colorFormItem.didChange
        }
        
    }
    
    private var changeHandler: (UIColor) -> () = { _ in }
    
    func setConstrints() {
        
        self.contentView.addSubview(cellBackgroundView)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: sideOffset),
            cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -sideOffset),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        cellBackgroundView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: 0),
        ])
        
        stackView.addSubview(cellTitle)
        NSLayoutConstraint.activate([
            cellTitle.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            cellTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),

        ])
        
        stackView.addSubview(colorButton)
        NSLayoutConstraint.activate([
            colorButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            colorButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0)
        ])
    }
    
}


extension UIButton {
    
    func setupButtonCircleStyle() {
        self.layer.cornerRadius = 0.5 * self.frame.size.width
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
