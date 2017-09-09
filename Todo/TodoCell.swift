//
//  TodoCell.swift
//  Todo
//
//  Created by 尹久盼 on 06/09/2017.
//  Copyright © 2017 尹久盼. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    
    var todoString: String? {
        didSet {
            todoLabel.text = todoString
        }
    }
}
