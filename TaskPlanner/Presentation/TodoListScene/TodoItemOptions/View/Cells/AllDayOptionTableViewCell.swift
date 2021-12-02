//
//  AllDayOptionTableViewCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 01.11.2021.
//

import UIKit

class AllDayOptionTableViewCell: TodoItemOptionsTableViewCell {
    
    var cellDelegate: SwitchCellDelegate?
    
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
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.backgroundColor = .clear
        return label
    }()
    
    var switchAllDay: UISwitch = {
       let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()


    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        switchAllDay.addTarget(self, action: #selector(switchDidChange), for: .touchUpInside)
        
        setConstrints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        changeHandler = { _ in }
        
    }

    private var changeHandler: (Bool) -> () = { _ in }
    
    @objc private func switchDidChange() {
        changeHandler(switchAllDay.isOn)
        print("AllDayCell switchDidChange() called")
    }
    
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
        
        stackView.addSubview(switchAllDay)
        NSLayoutConstraint.activate([
            switchAllDay.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            switchAllDay.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0)
        ])
    }
}
