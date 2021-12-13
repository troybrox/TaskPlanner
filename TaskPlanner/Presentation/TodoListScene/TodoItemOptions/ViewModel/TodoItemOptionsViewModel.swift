//
//  TodoItemOptionsViewModel.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 17.11.2021.
//

import Foundation

struct TodoItemOptionsViewModelClosures {
    let cancel: () -> Void
    let saveTodoItem: (TodoItem) -> Void
}

protocol TodoItemOptionsViewModelInput {
    func viewDidLoad()
    func didSave()
    func didCancel()
    func alertDateTimeDidSelect(date: Date, dateType: DateTimeInputType)
    func setColor(color: TodoItemColor)
}

protocol TodoItemOptionsViewModelOtput {
    var inputSections: [InputSectionViewModel] { get }
    var title: Observable<String> { get }
    var description: Observable<String> { get }
    var startDate: Observable<Date> { get }
    var finishDate: Observable<Date> { get }
    var color: Observable<TodoItemColor> { get }
    var isEmpty: Bool { get }
    var numberOfSections: Int { get }
    var isAwailable: Bool { get }
    var screenTitle: String { get }
    func numberOfRowsInSection(section: Int) -> Int
    func getInputCellViewModel(at indexPath: IndexPath) -> InputCellViewModel
}

protocol TodoItemOptionsViewModel : TodoItemOptionsViewModelInput, TodoItemOptionsViewModelOtput { }
    

final class DefaultTodoItemOptionsViewModel : TodoItemOptionsViewModel {
    
    private let addTodoItemUseCase: AddTodoItemUseCase
    private let closures:  TodoItemOptionsViewModelClosures?
    private var todoItem: TodoItem = TodoItem()

    private var titleInputVM: OneLineInputCellViewModel!
    private var descriptionInputVM: MultiLineInputCellViewModel!
    private var startDateInputVM: DateInputCellViewModel!
    private var finishDateInputVM: DateInputCellViewModel!
    private var colorInputVM: ColorInputCellViewModel!
    
    // MARK: - OUTPUT
        
    var inputSections: [InputSectionViewModel] = []
    
    var title: Observable<String> = Observable("")
    
    var description: Observable<String> = Observable("")
    
    var startDate: Observable<Date> = Observable(Date())
    
    var finishDate: Observable<Date> = Observable(Date().addingTimeInterval(3600))
    
    var color: Observable<TodoItemColor> = Observable(TodoItemColor.blue)
    
    var isEmpty: Bool { return title.value.isEmpty }
    
    var numberOfSections: Int { return inputSections.count }
    
    var isAwailable: Bool { return !isEmpty }
    
    var screenTitle: String { return "" }
    
    // MARK: - Init
    
    init(addTodoItemUseCase: AddTodoItemUseCase, closures: TodoItemOptionsViewModelClosures? = nil) {
        self.closures = closures
        self.addTodoItemUseCase = addTodoItemUseCase
    }
    
    init(todoItem: TodoItem, addTodoItemUseCase: AddTodoItemUseCase, date: Date, closures: TodoItemOptionsViewModelClosures? = nil) {
        self.todoItem = todoItem
        self.closures = closures
        self.addTodoItemUseCase = addTodoItemUseCase
        
        self.startDate.value = getStartDateForNow(date: date) ?? Date()
        self.finishDate.value = startDate.value.addingTimeInterval(3600)
    }
    
    // MARK: - Private
    
    private func initInputItems() {

        titleInputVM = OneLineInputCellViewModel(text: "", didChange: { [weak self] (value) in
            self?.title.value = value
            self?.updateItems()
            print("\ndidChange() titleInputVM text value = \(value)\n")
        })
        
        startDateInputVM = DateInputCellViewModel(type: .start, date: startDate.value, didChange: { [weak self] (value) in
            self?.startDate.value = value
            self?.updateItems()
            print("\ndidChange() startDateInputVM value = \(value)\n")
        })
        
        finishDateInputVM = DateInputCellViewModel(type: .finish, date: finishDate.value, didChange: { [weak self] (value) in
            self?.finishDate.value = value
            self?.updateItems()
            print("\ndidChange() finishDateInputVM value = \(value)\n")
        })
        
        colorInputVM = ColorInputCellViewModel(color: .blue, didChange: { [weak self] (color) in
            self?.color.value = color
            self?.updateItems()
        })
        

        
        descriptionInputVM = MultiLineInputCellViewModel(text: "", didChange: { [weak self] (value) in
            self?.description.value = value
            self?.updateItems()
            print("\ndidChange() descriptionInputVM text value = \(value)\n")
        })
        
        updateItems()
    }
    
    private func updateItems() {
        
        titleInputVM.text = title.value
        descriptionInputVM.text = description.value
        colorInputVM.color = color.value
        
        inputSections = [
            InputSectionViewModel(inputRows: [titleInputVM]),
            InputSectionViewModel(inputRows: [startDateInputVM, finishDateInputVM]),
            InputSectionViewModel(inputRows: [colorInputVM]),
            InputSectionViewModel(inputRows: [descriptionInputVM])
        ]
    }
    
    private func update() { }
    
    private func updateTitle() { }
    
    private func getStartDateForNow(date: Date) -> Date? {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        let currentDateTime = Date()
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        dateComponents.hour = calendar.component(.hour, from: currentDateTime)
        dateComponents.minute = calendar.component(.minute, from: currentDateTime)
        return dateComponents.date
    }
}

// MARK: - INPUT

extension DefaultTodoItemOptionsViewModel {
    
    func viewDidLoad() {
        initInputItems()
    }
    
    func didSave() {
        todoItem.title = title.value
        todoItem.description = description.value
        todoItem.startDate = startDate.value
        todoItem.finishDate = finishDate.value
        todoItem.color = color.value // [!]
        
        addTodoItemUseCase.start(todoItem: todoItem, completion: {
            self.closures?.saveTodoItem(self.todoItem)
        })
    }
    
    func didCancel() { }
    
    func alertDateTimeDidSelect(date: Date, dateType: DateTimeInputType) {
        
        // TODO: check if change single public values
        
        switch dateType {
        case .start:
            startDateInputVM.date = date
            startDateInputVM.didChange(date)
            if date > finishDateInputVM.date {
                finishDateInputVM.date = date
                finishDateInputVM.didChange(date)
            }
            print("startDateInputVM.date = \(startDateInputVM.date)")
            
        case .finish:
            finishDateInputVM.date = date
            finishDateInputVM.didChange(date)
            if date < startDateInputVM.date {
                startDateInputVM.date = date
                startDateInputVM.didChange(date)
            }
            print("finishDateInputVM.date = \(finishDateInputVM.date)")
        }
    }
    
    func setColor(color: TodoItemColor) {
        colorInputVM.color = color
        colorInputVM.didChange(color)
    }
}

// MARK: - OUTPUT. View event methods

extension DefaultTodoItemOptionsViewModel {
    
    func numberOfRowsInSection(section: Int) -> Int {
        return inputSections[section].inputRows.count
    }
    
    func getInputCellViewModel(at indexPath: IndexPath) -> InputCellViewModel {
        return inputSections[indexPath.section].inputRows[indexPath.row]
    }
}
