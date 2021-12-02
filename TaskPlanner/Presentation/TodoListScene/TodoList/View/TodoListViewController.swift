//
//  ViewController.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 25.10.2021.
//

import UIKit
import FSCalendar
import Foundation

class TodoListViewController: UIViewController {

    private var fsCalendar: FSCalendar!
    private var showHideCalendarButton: UIButton!
    private var tableView: UITableView!
    
    private var buttonImageDown: UIImage!
    private var buttonImageUp: UIImage!
    private var calendarHeightConstraint: NSLayoutConstraint!
    private var cellHeightDictionary: NSMutableDictionary!
    
    private var viewModel: TodoListViewModel!
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: TodoListViewModel) -> TodoListViewController {
        let view = TodoListViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.didSelectDate(selectedDate: fsCalendar.today!) // TODO: if just added todoItem, set its start date
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: TodoListViewModel) {
        viewModel.tableItems.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.date.observe(on: self) { [weak self] _ in self?.updateTable()} /// updateDate($0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        updateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private
    
    private func setupViews() {
        title = viewModel.screenTitle
        self.view.backgroundColor = .white
        setupNavigationItem()
        setupFSCalendar()
        setupShowHideCalendarButton()
        setupTableView()
        setConstraints()
    }
    
    private func updateItems() {
        tableView.reloadData()
        tableView.beginUpdates() // ?
        tableView.endUpdates() // ?
    }
    
    private func updateDate(_ date: Date) {
        /// метод вызывается после изменения даты в viewModel
    }
    
    private func updateTable() {
        self.tableView.reloadData()
        self.tableView.beginUpdates()
//        self.tableView.reloadData()
        self.tableView.endUpdates()
        scrollToTop()
    }
}




//MARK: - PressViewProtocol

extension TodoListViewController: PressViewProtocol {
    func cardViewTapped(indexPath: IndexPath) {
        print("TAP todo item")
    }
}


// MARK: - FSCalendar

extension TodoListViewController {
    
    private func setupFSCalendar() {
        fsCalendar = FSCalendar()
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.translatesAutoresizingMaskIntoConstraints = false
        fsCalendar.backgroundColor = .clear
        fsCalendar.scope = .week
        fsCalendar.firstWeekday = 2
        fsCalendar.locale = Locale(identifier: "ru_RU")
        fsCalendar.appearance.caseOptions = [.headerUsesCapitalized]
        setSwipeActions()
    }
    
    private func setSwipeActions() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleCalendarSwipe))
        swipeUp.direction = .up
        fsCalendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleCalendarSwipe))
        swipeDown.direction = .down
        fsCalendar.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleCalendarSwipe(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .up:
            if fsCalendar.scope == .month {
                setCalendarType(.week)
            }
            
        case .down:
            if fsCalendar.scope == .week {
                setCalendarType(.month)
            }
            
        default:
            break
        }
        
    }
    
    private func setCalendarType(_ calendarType: FSCalendarScope) {
        fsCalendar.setScope(calendarType, animated: true)
        switch calendarType {
        case .month:
            showHideCalendarButton.setImage(buttonImageUp, for: .normal)
        case .week:
            showHideCalendarButton.setImage(buttonImageDown, for: .normal)
        }
    }
    
}

// MARK: - TableView

extension TodoListViewController {
    
    enum MainTableCellIndentifiers: String {
        case todoItem
        case hourSeparator
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.frame = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: MainTableCellIndentifiers.todoItem.rawValue)
        tableView.register(HourRowTableViewCell.self, forCellReuseIdentifier: MainTableCellIndentifiers.hourSeparator.rawValue)
        
        if let separatorColor = tableView.separatorColor {
            HourRowTableViewCell.separatorColor = separatorColor
        }
        
        cellHeightDictionary = NSMutableDictionary()
    }
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topRow, at: .top, animated: false)
    }
}

// MARK: - Buttons

extension TodoListViewController {
    
    private func setupNavigationItem() {
        self.navigationItem.title = viewModel.screenTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func setupShowHideCalendarButton() {
        setupButtonImages()
        showHideCalendarButton = UIButton()
        if #available(iOS 15, *) {
            var buttonConfiguration = UIButton.Configuration.borderless()
            buttonConfiguration.image = buttonImageDown
            showHideCalendarButton = UIButton(configuration: buttonConfiguration, primaryAction: nil)
        } else {
            showHideCalendarButton.setImage(buttonImageDown, for: .normal)
            showHideCalendarButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        }
        showHideCalendarButton.translatesAutoresizingMaskIntoConstraints = false
        showHideCalendarButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
    }
    
    private func setupButtonImages() {
        buttonImageDown = UIImage()
        if let image = UIImage(named: "ButtonDown") {
            buttonImageDown = resizeImage(image: image, targetSize: CGSize(width: 22, height: 8))
        }
        
        buttonImageUp = UIImage()
        if let image = UIImage(named: "ButtonUp") {
            buttonImageUp = resizeImage(image: image, targetSize: CGSize(width: 22, height: 8))
        }
    }
    
    @objc private func showHideButtonTapped() {
        if fsCalendar.scope == .week {
            setCalendarType(.month)
        } else {
            setCalendarType(.week)
        }
    }
     
    @objc private func addButtonTapped() {
        print("Add button tapped")
        viewModel.didSelectAddTodoItem()
    }
}

// MARK: - Set Constraints

extension TodoListViewController {
    
    private func setConstraints() {
        
        view.addSubview(fsCalendar)
        
        calendarHeightConstraint = NSLayoutConstraint(item: fsCalendar,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 300)
        fsCalendar.addConstraint(calendarHeightConstraint)
        
        if #available(iOS 11.0, *) {
            fsCalendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            fsCalendar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        }
        NSLayoutConstraint.activate([
            fsCalendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            fsCalendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        view.addSubview(showHideCalendarButton)
        NSLayoutConstraint.activate([
            showHideCalendarButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            showHideCalendarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showHideCalendarButton.topAnchor.constraint(equalTo: fsCalendar.bottomAnchor, constant: 0)
        ])
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: showHideCalendarButton.bottomAnchor, constant: 3),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


//MARK: - FSCalendarDataSource, FSCalendarDelegate

extension TodoListViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("\nselected date - \(date)")
        viewModel.didSelectDate(selectedDate: date)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MainTableViewCell()
        let cellViewModel = viewModel.getTableCellViewModel(for: indexPath)
        
        switch cellViewModel {
        case is TodoListCardItemViewModel:
            cell = self.tableView.dequeueReusableCell(withIdentifier: MainTableCellIndentifiers.todoItem.rawValue, for: indexPath) as! TodoItemTableViewCell
            if let todoItemCardCell = cell as? TodoItemTableViewCell {
                todoItemCardCell.fill(with: cellViewModel)
                todoItemCardCell.cellDelegate = self
                DispatchQueue.main.async {
                    cell.setStyle()
                }
            }
            
        case is TodoListHourItemViewModel:
            cell = self.tableView.dequeueReusableCell(withIdentifier: MainTableCellIndentifiers.hourSeparator.rawValue, for: indexPath) as! HourRowTableViewCell
            if let hourCell = cell as? HourRowTableViewCell {
                hourCell.fill(with: cellViewModel)
            }
        default:
            break
        }
        
        cell.cellTodoItemDelegate = self
        cell.index = indexPath
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isCellTodoItem(at: indexPath) {
            return 70
        }
        else if indexPath.row + 1 < viewModel.numberOfItems && viewModel.isCellTodoItem(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) {
            return 14
        }
        else {
            return 38
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellHeightDictionary.object(forKey: indexPath) != nil {
            let height = cellHeightDictionary.object(forKey: indexPath) as! CGFloat
            return height
        }
        return UITableView.automaticDimension
    }
    

}

// MARK: - UIViewControllerTransitioningDelegate

extension TodoListViewController : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - TodoItemCellDelegate

extension TodoListViewController : TodoItemCellDelegate {
    
    func itemTapped(viewModel: TodoListCardItemViewModel) {
        let slideVC = TodoItemView()
        slideVC.bindViewModel(viewModel: viewModel)
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
}

// MARK: - Functions

private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
