//
//  HourRowTableViewCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 31.10.2021.
//

import UIKit

class HourRowTableViewCell: MainTableViewCell {
    
    static let reuseIdentifier = String(describing: HourRowTableViewCell.self)
    static let height = CGFloat(38)
    static var separatorColor: UIColor = UIColor()
    
    private var cellBackgroundView: UIView!
    private var hourLineStackView: UIStackView!
    private var timeLabel: UILabel!
    private var lineView: UIView!
    
    private var viewModel: TodoListHourItemViewModel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(viewModel: TodoListHourItemViewModel) {
        self.viewModel = viewModel
        timeLabel.text = viewModel.hourLabel
    }
    
    
    override func fill(with viewModel: TodoListItemViewModel) {
        if let viewModel = viewModel as? TodoListHourItemViewModel {
            self.viewModel = viewModel
            timeLabel.text = viewModel.hourLabel
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupBackground()
        setupHourSeparator()
        setConstraints()
    }
}


// MARK: - Set Constraints

extension HourRowTableViewCell {
    
    private func setConstraints() {
        
        self.contentView.addSubview(cellBackgroundView)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        cellBackgroundView.addSubview(hourLineStackView)
        NSLayoutConstraint.activate([
            hourLineStackView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 0),
            hourLineStackView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 0),
            hourLineStackView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: 0)
        ])
        
        hourLineStackView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: hourLineStackView.topAnchor, constant: 0),
            timeLabel.leadingAnchor.constraint(equalTo: hourLineStackView.leadingAnchor, constant: 0)
        ])

        hourLineStackView.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            lineView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 5),
            lineView.trailingAnchor.constraint(equalTo: hourLineStackView.trailingAnchor, constant: 0),
        ])
    }
}

// MARK: - Cell background

extension HourRowTableViewCell {

    private func setupBackground() {
        cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .clear
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Hour separator time-line

extension HourRowTableViewCell {
    
    private func setupHourSeparator() {
        hourLineStackView = UIStackView()
        hourLineStackView.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel = UILabel()
        timeLabel.text = ""
        timeLabel.textColor = .lightGray
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textAlignment = .left
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.backgroundColor = .clear
        
        lineView = UIView()
        lineView.backgroundColor = HourRowTableViewCell.separatorColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
    }
}
