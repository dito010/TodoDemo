//
//  DataSources.swift
//  Todo
//
//  Created by 尹久盼 on 06/09/2017.
//  Copyright © 2017 尹久盼. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    enum Section: Int {
        case input = 0, todos, max
    }
    
    weak var owner: TodoViewController?
    var todos: [String]
    
    init(owner: TodoViewController?, todos: [String]) {
        self.owner = owner
        self.todos = todos
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        
        switch section {
        case .input:
            return 1
        case .todos:
            return todos.count
        case .max:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseID, for: indexPath) as! AddCell
            cell.delegate = owner
           return cell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: todoCellReuseID, for: indexPath) as! TodoCell
            cell.todoLabel.text = todos[indexPath.row]
            return cell
        case .max:
            fatalError()
        }
    }
}
