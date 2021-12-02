//
//  TodoItemTableViewController.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 23.11.2021.
//

import UIKit

class TodoItemTableViewController: UITableViewController {
    
    private var viewModel: TodoItemOptionsViewModel!
    private var heightOfColorSelectView: Int!
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: TodoItemOptionsViewModel) -> TodoItemTableViewController {
        let view = TodoItemTableViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: TodoItemOptionsViewModel) {
        viewModel.title.observe(on: self) { [weak self] _ in self?.checkValues() }
        viewModel.startDate.observe(on: self) { [weak self] _ in self?.updateCells() }
        viewModel.finishDate.observe(on: self) { [weak self] _ in self?.updateCells() }
        viewModel.color.observe(on: self) { [weak self] _ in self?.updateCells() }
        viewModel.description.observe(on: self) { [weak self] _ in self?.checkValues() }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        title = viewModel.screenTitle
        setupNavigationItem()
        setupTableView()
    }
    
    private func checkValues() {
        self.navigationItem.rightBarButtonItem?.isEnabled = viewModel.isAwailable
    }
    
    private func updateCells() {
        self.navigationItem.rightBarButtonItem?.isEnabled = viewModel.isAwailable
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
}

// MARK: - Buttons

extension TodoItemTableViewController {
    
    private func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = viewModel.isAwailable
        self.navigationItem.rightBarButtonItem?.isEnabled = viewModel.title.value != ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))
    }
    
    @objc private func saveButtonTapped() {
        print("saveButtonTapped() called")
        viewModel.didSave()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        exitAlert(completionHandler: {
            self.viewModel.didCancel()
            self.navigationController?.popViewController(animated: true)
        })
    }
}

// MARK: - TableView

extension TodoItemTableViewController {
    
    private enum ReuseIndentifiers: String {
        case textInput
        case noteInput
        case colorInput
        case optionsHeader
        case dateTimeInput
        case datePickerInput
        case allDayInput
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 232/255, green: 242/255, blue: 1, alpha: 1)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ReuseIndentifiers.optionsHeader.rawValue)
        tableView.register(OneLineOptionTableViewCell.self, forCellReuseIdentifier: ReuseIndentifiers.textInput.rawValue)
        tableView.register(MultiLineOptionTableCell.self, forCellReuseIdentifier: ReuseIndentifiers.noteInput.rawValue)
        tableView.register(DateTimeOptionTableViewCell.self, forCellReuseIdentifier: ReuseIndentifiers.dateTimeInput.rawValue)
        tableView.register(ColorOptionTableViewCell.self, forCellReuseIdentifier: ReuseIndentifiers.colorInput.rawValue)
        tableView.register(AllDayOptionTableViewCell.self, forCellReuseIdentifier: ReuseIndentifiers.allDayInput.rawValue)
    }
}




// MARK: - UITableViewController

extension TodoItemTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = viewModel.getInputCellViewModel(at: indexPath)
        let cell: TodoItemOptionsTableViewCell
        
        switch cellViewModel {
            
        case is OneLineInputCellViewModel:
            cell = tableView.dequeueReusableCell(withIdentifier: ReuseIndentifiers.textInput.rawValue, for: indexPath) as! OneLineOptionTableViewCell
            cell.fill(with: cellViewModel as! OneLineInputCellViewModel)
        
        case is DateInputCellViewModel:
            cell = tableView.dequeueReusableCell(withIdentifier: ReuseIndentifiers.dateTimeInput.rawValue, for: indexPath) as! DateTimeOptionTableViewCell
            cell.fill(with: cellViewModel as! DateInputCellViewModel)
            if let cell = cell as? DateTimeOptionTableViewCell {
                cell.cellDelegate = self
            }
        
        case is ColorInputCellViewModel:
            cell = tableView.dequeueReusableCell(withIdentifier: ReuseIndentifiers.colorInput.rawValue, for: indexPath) as! ColorOptionTableViewCell
            cell.fill(with: cellViewModel as! ColorInputCellViewModel)
            if let cell = cell as? ColorOptionTableViewCell {
                cell.cellDelegate = self
            }
        
        case is MultiLineInputCellViewModel:
            cell = tableView.dequeueReusableCell(withIdentifier: ReuseIndentifiers.noteInput.rawValue, for: indexPath) as! MultiLineOptionTableCell
            cell.fill(with: cellViewModel as! MultiLineInputCellViewModel)
            
        case is AllDayInputCellViewModel:
            cell = tableView.dequeueReusableCell(withIdentifier: ReuseIndentifiers.allDayInput.rawValue, for: indexPath) as! AllDayOptionTableViewCell
            cell.fill(with: cellViewModel as! AllDayInputCellViewModel)
        
        default:
            fatalError("Unknown model \(cellViewModel)")
        }
        
        self.setTableCellStyle(tableView, cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.getInputCellViewModel(at: indexPath).isMultiLineInputItem() {
            return 200
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if #available(iOS 15, *) {
            if section == 0 { return 0}
            return 15
        }
        if section == 0 { return 15}
        return 30
    }
}

// MARK: - Customizing Table View Cell

extension TodoItemTableViewController {
    
    private func setTableCellStyle(_ tableView: UITableView, cell: TodoItemOptionsTableViewCell, indexPath: IndexPath) {
        print("setTableCellStyle() called")
        
        if (cell.responds(to: #selector(getter: UIView.tintColor))) {
                
            if tableView == self.tableView {
                let cornerRadius: CGFloat = 12.0
                let layer: CAShapeLayer = CAShapeLayer()
                let path: CGMutablePath = CGMutablePath()
                let bounds: CGRect = CGRect(x: cell.bounds.minX + cell.sideOffset, y: cell.bounds.minY, width: cell.bounds.width - 2 * cell.sideOffset, height: (tableView.delegate?.tableView!(tableView, heightForRowAt: indexPath))!)
                var addLine: Bool = false

                cell.backgroundColor = .clear
                bounds.insetBy(dx: 25.0, dy: 0.0)
                
                if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

                } else if indexPath.row == 0 {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                    addLine = true

                } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))

                } else {
                    path.addRect(bounds)
                    addLine = true
                }

                layer.path = path
                layer.fillColor = UIColor.white.withAlphaComponent(1).cgColor

                if addLine {
                    let lineOffset: CGFloat = 15.0
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
                    lineLayer.frame = CGRect(x: bounds.minX + lineOffset, y: bounds.size.height - lineHeight, width: bounds.size.width - lineOffset, height: lineHeight)
                    lineLayer.backgroundColor = tableView.separatorColor?.cgColor
                    layer.addSublayer(lineLayer)
                }
                
                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = .clear
                cell.backgroundView = testView
            }
        }
    }
}

// MARK: - DateTimeCellDelegate

extension TodoItemTableViewController : DateTimeCellDelegate {
    
    func dateTimeButtonChanged(date: Date, cellRow: Int) { }
    
    func alertDatePicker(currentDate: Date, dateType: DateTimeInputType) {
        alertDateTime(currentDate: currentDate) { (date) in
            self.viewModel.alertDateTimeDidSelect(date: date, dateType: dateType)
        }
    }
}

// MARK: - ColorCellDelegate

extension TodoItemTableViewController : ColorCellDelegate {
    
    func colorButtonDidTap() {
        let slideColorVC = ColorSelectView()
        heightOfColorSelectView = Int(slideColorVC.getHeight())
        heightOfColorSelectView = Int(slideColorVC.viewHeight)
        slideColorVC.modalPresentationStyle = .custom
        slideColorVC.transitioningDelegate = self
        slideColorVC.selectColorDelegate = self
        self.present(slideColorVC, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension TodoItemTableViewController : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SelectColorPresentationController(presentedViewController: presented, presenting: presenting, height: heightOfColorSelectView)
    }
}

// MARK: - SelectColorDelegate

extension TodoItemTableViewController : SelectColorDelegate {
    
    func blueColorDidSelect() {
        viewModel.setColor(color: .blue)
    }
    
    func redColorDidSelect() {
        viewModel.setColor(color: .red)
    }
    
    func greenColorDidSelect() {
        viewModel.setColor(color: .green)
    }
    
    func yellowColorDidSelect() {
        viewModel.setColor(color: .yellow)
    }
}
