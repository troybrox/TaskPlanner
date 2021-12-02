//
//  TodoListViewModel.swift
//  TaskPlanner
//
//  Created by Daniil Alekseev on 10.11.2021.
//

import Foundation

struct TodoListViewModelClosures {
    let showTodoItemDetails: (TodoItem) -> Void
    let showTodoItemOptions: (Date) -> Void
}

protocol TodoItemViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectDate(selectedDate: Date)
    func didSelectItem(at indexPath: IndexPath)
    func didSelectItem(at index: Int)
}

protocol TodoItemViewModelOtput {
    var date: Observable<Date> { get }
    var tableItems: Observable<[TodoListItemViewModel]> { get }
    var isEmpty: Bool { get }
    var numberOfItems: Int { get }
    var screenTitle: String { get }
    var numberOfTodoItems: Int { get }
    var reloadItems: Observable<Bool> { get }
    func getTableCellViewModel(for indexPath: IndexPath) -> TodoListItemViewModel
    func isCellTodoItem(at indexPath: IndexPath) -> Bool
    func getTodoItemCardViewModel(at indexPath: IndexPath) -> TodoListCardItemViewModel?
    func getHourViewModel(at indexPath: IndexPath) -> TodoListHourItemViewModel?
    func didSelectAddTodoItem()
}


protocol TodoListViewModel: TodoItemViewModelInput, TodoItemViewModelOtput { }


final class DefaultTodoListViewModel : TodoListViewModel {
    
    private let fetchTodoItemsUseCase: FetchTodoItemsUseCase
    private let closures: TodoListViewModelClosures?
    
    private var todoItems: [TodoItem] = []
    
    private var separatorItems: [TodoListHourItemViewModel] {
        var items = [TodoListHourItemViewModel]()
        for num in 0...24 {
            items.append(TodoListHourItemViewModel(hour: num))
        }
        return items
    }
    
    // MARK: - OUTPUT
    
    var date: Observable<Date> = Observable(Date())
    let tableItems: Observable<[TodoListItemViewModel]> = Observable([])
    let reloadItems: Observable<Bool> = Observable(true)
    var isEmpty: Bool { return todoItems.isEmpty }
    var screenTitle: String = NSLocalizedString("Ежедневник", comment: "")
    var numberOfItems: Int { return tableItems.value.count }
    var numberOfTodoItems: Int { return todoItems.count }
    
    // MARK: - Init
    
    init(fetchTodoItemsUseCase: FetchTodoItemsUseCase,
         actions: TodoListViewModelClosures? = nil) {
        self.closures = actions
        self.fetchTodoItemsUseCase = fetchTodoItemsUseCase
    }
    
    // MARK: - Private
    
    private func initItems(_ items: [TodoItem]) {
        
        todoItems = items
        
        if isEmpty {
            tableItems.value = separatorItems
            return
        }
       
        var index = 0
        for separator in separatorItems {
            if index >= todoItems.count {
                tableItems.value.append(separator)
            }
            else if separator.hour <= todoItems[index].getStartHour() {
                tableItems.value.append(separator)
            }
            else {
                while index < todoItems.count && separator.hour > todoItems[index].getStartHour()  {
                    let todoItemCard = TodoListCardItemViewModel(todoItem: todoItems[index])
                    tableItems.value.append(todoItemCard)
                    index+=1
                }
                tableItems.value.append(separator)
            }
        }
    }
    
    private func resetItems() {
        todoItems.removeAll()
        tableItems.value.removeAll()
    }
    
    private func load(selectedDate: Date) {
        date.value = selectedDate
        fetchTodoItemsUseCase.start(selectedDate: selectedDate, completion: { items in
            self.initItems(items)
        })
    }
    
    private func update(selectedDate: Date) {
        resetItems()
        load(selectedDate: selectedDate)
    }
    
}

// MARK: - INPUT

extension DefaultTodoListViewModel {
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        update(selectedDate: date.value)
    }
    
    func didSelectDate(selectedDate: Date) {
        update(selectedDate: selectedDate)
    }
    
    func didSelectItem(at index: Int) {
        closures?.showTodoItemDetails(todoItems[index])
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        closures?.showTodoItemDetails(todoItems[indexPath.row])
    }
    
    func didSelectAddTodoItem() {
        closures?.showTodoItemOptions(date.value)
    }
}

// MARK: - OUTPUT. View event methods

extension DefaultTodoListViewModel {
    
    func getTableCellViewModel(for indexPath: IndexPath) -> TodoListItemViewModel {
        return tableItems.value[indexPath.row]
    }
    
    func isCellTodoItem(at indexPath: IndexPath) -> Bool {
        return tableItems.value[indexPath.row] is TodoListCardItemViewModel
    }
    
    func getTodoItemCardViewModel(at indexPath: IndexPath) -> TodoListCardItemViewModel? {
        var result: TodoListCardItemViewModel? = nil
        if let itemViewModel = tableItems.value[indexPath.row] as? TodoListCardItemViewModel {
            result = itemViewModel
        }
        return result
    }
    
    func getHourViewModel(at indexPath: IndexPath) -> TodoListHourItemViewModel? {
        var result: TodoListHourItemViewModel? = nil
        if let hourViewModel = tableItems.value[indexPath.row] as? TodoListHourItemViewModel {
            result = hourViewModel
        }
        return result
    }
}
