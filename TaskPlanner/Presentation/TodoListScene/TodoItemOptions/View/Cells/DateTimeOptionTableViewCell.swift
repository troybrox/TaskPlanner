//
//  DateTimeOptionTableViewCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 29.10.2021.
//

import UIKit

class DateTimeOptionTableViewCell : TodoItemOptionsTableViewCell {
    
    var cellDelegate: DateTimeCellDelegate?
    
    private var cellBackgroundView: UIView!
    private var cellTitle: UILabel!
    private var dateTimeButton: UIButton!
    private var stackView: UIStackView!
    
    private var viewModel: DateInputCellViewModel!
    
    // MARK: - Fill
    
    override func fill(with viewModel: InputCellViewModel) {
        if let viewModel = viewModel as? DateInputCellViewModel {
            self.viewModel = viewModel
            let dateTimeFormatter = DateFormatter()
            dateTimeFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let dateTimeString = dateTimeFormatter.string(from: viewModel.date)
            cellTitle.text = viewModel.title
            dateTimeButton.setTitle(dateTimeString, for: .normal)
        }
    }
    
    // MARK: - Initializing a Cell
    
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
    
    // MARK: - Private
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupBackgroundView()
        setupStackView()
        setupTitleLabel()
        setupDateTimeButton()
        setConstraints()
    }
}


// MARK: - Set Constrints

extension DateTimeOptionTableViewCell {
    
    func setConstraints() {
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
            stackView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: 0),
        ])
        
        stackView.addSubview(cellTitle)
        NSLayoutConstraint.activate([
            cellTitle.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            cellTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),

        ])

        stackView.addSubview(dateTimeButton)
        NSLayoutConstraint.activate([
            dateTimeButton.widthAnchor.constraint(equalToConstant: 155),
            dateTimeButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5),
            dateTimeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            dateTimeButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - Cell Content

extension DateTimeOptionTableViewCell {

    private func setupBackgroundView() {
        cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .clear
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Labels

extension DateTimeOptionTableViewCell {
    
    private func setupTitleLabel() {
        cellTitle = UILabel()
        cellTitle.textColor = .black
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.font = UIFont.systemFont(ofSize: 16)
        cellTitle.textAlignment = .left
        cellTitle.adjustsFontSizeToFitWidth = false
        cellTitle.backgroundColor = .clear
    }
}

// MARK: - Buttons

extension DateTimeOptionTableViewCell {
    
    private func setupDateTimeButton() {
        dateTimeButton = UIButton()
        dateTimeButton.setTitle("", for: .normal)
        dateTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        dateTimeButton.setTitleColor(.black, for: .normal)
        dateTimeButton.layer.cornerRadius = 8.0
        dateTimeButton.backgroundColor = UIColor(red: 189/255, green: 209/255, blue: 240/255, alpha: 1)
        dateTimeButton.translatesAutoresizingMaskIntoConstraints = false
        dateTimeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        cellDelegate?.alertDatePicker(currentDate: viewModel.date, dateType: viewModel.type)
    }
}
