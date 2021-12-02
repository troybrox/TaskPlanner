//
//  MainTableViewCell.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 25.10.2021.
//

import UIKit

class TodoItemTableViewCell: MainTableViewCell {
    
    static let reuseIdentifier = String(describing: TodoItemTableViewCell.self)
    static let height = CGFloat(70)
    
    var cellDelegate: TodoItemCellDelegate?
    
    private var cellBackgroundView: UIView!
    private var cellStackView: UIStackView!
    private var cellLeftColorTagView: UIView!
    private var cellRightContentView: UIView!
    private var contentStackView: UIStackView!
    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    
    private var viewModel: TodoListCardItemViewModel!

    // MARK: - Fill
    
    func fill(with viewModel: TodoListCardItemViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        timeLabel.text = viewModel.timeRange
        cellLeftColorTagView.backgroundColor = viewModel.color.withAlphaComponent(0.8)
        cellRightContentView.backgroundColor = viewModel.color.withAlphaComponent(0.2)
    }
    
    override func fill(with viewModel: TodoListItemViewModel) {
        if let viewModel = viewModel as? TodoListCardItemViewModel {
            self.viewModel = viewModel
            titleLabel.text = viewModel.title
            timeLabel.text = viewModel.timeRange
            cellLeftColorTagView.backgroundColor = viewModel.color.withAlphaComponent(0.8)
            cellRightContentView.backgroundColor = viewModel.color.withAlphaComponent(0.2)
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
    
    override func setStyle() {
        self.cellLeftColorTagView.roundCorners([.topLeft, .bottomLeft], radius: 3)
        self.cellRightContentView.roundCorners([.topRight, .bottomRight], radius: 3)
    }
    
    // MARK: - Private
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupBackgroundView()
        setupContentStackView()
        setupTitleLabel()
        setupTimeLabel()
        setConstraints()
    }
}


// MARK: - Set Constraints

extension TodoItemTableViewCell {
    
    private func setConstraints() {
        
        self.contentView.addSubview(cellBackgroundView)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7.5),
            cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7.5),
        ])
        
        cellBackgroundView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 0),
            cellStackView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 0),
            cellStackView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: 0),
            cellStackView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: 0),
        ])

        cellStackView.addSubview(cellLeftColorTagView)
        NSLayoutConstraint.activate([
            cellLeftColorTagView.widthAnchor.constraint(equalToConstant: 6),
            cellLeftColorTagView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 0),
            cellLeftColorTagView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor, constant: 0),
            cellLeftColorTagView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: 0)
        ])

        cellStackView.addSubview(cellRightContentView)
        NSLayoutConstraint.activate([
            cellRightContentView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 0),
            cellRightContentView.leadingAnchor.constraint(equalTo: cellLeftColorTagView.trailingAnchor, constant: 0),
            cellRightContentView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor, constant: 0),
            cellRightContentView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: 0)
        ])

        cellRightContentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: cellRightContentView.topAnchor, constant: 5),
            contentStackView.leadingAnchor.constraint(equalTo: cellRightContentView.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: cellRightContentView.trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: cellRightContentView.bottomAnchor, constant: -5),
        ])
        
        contentStackView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: 0)
        ])
        
        contentStackView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),
        ])
    }
}

// MARK: - Cell background

extension TodoItemTableViewCell {

    private func setupBackgroundView() {
        cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .clear
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap))
        cellBackgroundView.addGestureRecognizer(tapGesture)
        
        cellStackView = UIStackView()
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cellLeftColorTagView = UIView()
        cellLeftColorTagView.layer.borderColor = UIColor.clear.cgColor
        cellLeftColorTagView.translatesAutoresizingMaskIntoConstraints = false
        cellLeftColorTagView.backgroundColor = .systemGreen
        
        cellRightContentView = UIView()
        cellRightContentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func backgroundViewDidTap() {
        cellDelegate?.itemTapped(viewModel: viewModel)
    }
}

// MARK: - Labels

extension TodoItemTableViewCell {
    
    private func setupContentStackView() {
        contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 15)
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .clear
    }
    
    private func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel.text = ""
        timeLabel.textColor = .darkGray
        timeLabel.font = UIFont(name: "Avenir Next", size: 12)
        timeLabel.textAlignment = .left
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.backgroundColor = .clear
    }
}
