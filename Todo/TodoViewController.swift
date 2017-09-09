//
//  TodoViewController.swift
//  Todo
//
//  Created by 尹久盼 on 05/09/2017.
//  Copyright © 2017 尹久盼. All rights reserved.
//

import UIKit

let inputCellReuseID = "inputCellReuseID"
let todoCellReuseID = "todoCellReuseID"

class TodoViewController: UITableViewController {
    
    struct State: StateType {
        var dataSource = DataSource(owner: nil, todos: [])
        var text: String = ""
    }
    
    enum Action: ActionType {
        case updateText(text: String)
        case addTodos(todos: [String])
        case removeTodo(index: Int)
        case loadTodos
    }
    
    enum Command: CommandType {
        case loadTodos(completion: ([String]) -> Void)
        case otherCommand
    }
    
    var store: Store<Action, Command, State>!
    
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = {
        [weak self]  (state: State, action: Action) in
        
        var state = state
        var command: Command? = nil
        
        switch action {
        case .updateText(let text):
            state.text = text
        case .addTodos(let todos):
            state.dataSource = DataSource(owner: self, todos: todos + state.dataSource.todos)
        case .removeTodo(let index):
            var oldTodos = state.dataSource.todos
            oldTodos.remove(at: index)
            state.dataSource = DataSource(owner: self, todos: oldTodos)
        case .loadTodos:
            command = Command.loadTodos(){self?.store.dispatch(TodoViewController.Action.addTodos(todos: $0))}
        }
        
        return (state, command)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: String(describing: AddCell.self), bundle: nil), forCellReuseIdentifier: inputCellReuseID)
        tableView.register(UINib(nibName: String(describing: TodoCell.self), bundle: nil), forCellReuseIdentifier: todoCellReuseID)
        
        let dataSource = DataSource(owner: self, todos: [])
        store = Store(reducer: reducer, initialState: State(dataSource: dataSource, text: ""))
        store.subscriber = stateDidChanged(state:previousState:command:)
        
        stateDidChanged(state: store.state, previousState: nil, command: nil)
        store.dispatch(.loadTodos)
    }
    
    func stateDidChanged(state: State, previousState: State?, command: Command?) {
        if let command = command {
            switch command {
            case .loadTodos(completion: let handler):
                DataStore.shared.fetchItems(completionHandler: handler)
            case .otherCommand:
                break
            }
        }
        
        if previousState != nil && previousState!.dataSource.todos != state.dataSource.todos {
            tableView.dataSource = state.dataSource
            tableView.reloadData()
            title = "TODO - (\(state.dataSource.todos.count))"
        }
        
        if previousState != nil && previousState!.text != state.text {
            let lengthEnough = state.text.characters.count > 3
            navigationItem.rightBarButtonItem?.isEnabled = lengthEnough
            
            let inputIndexPath = IndexPath(row: 0, section: DataSource.Section.input.rawValue)
            let cell = tableView.cellForRow(at: inputIndexPath) as? AddCell
            cell?.addTodoTextField.text = state.text
        }
        
        if previousState == nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func rightBarButtonDidClicked(_ sender: UIBarButtonItem) {
        store.dispatch(.addTodos(todos: [store.state.text]))
        store.dispatch(.updateText(text: ""))
    }
}

extension TodoViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == DataSource.Section.todos.rawValue else {
            return
        }
        store.dispatch(.removeTodo(index: indexPath.row))
    }
}

extension TodoViewController: AddCellDelegate {
    func addCellTextDidChanged(cell: AddCell, text: String?) {
        if let text = text {
            store.dispatch(.updateText(text: text))
        }
    }
}
