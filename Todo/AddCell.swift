//
//  AddCell.swift
//  Todo
//
//  Created by 尹久盼 on 06/09/2017.
//  Copyright © 2017 尹久盼. All rights reserved.
//

import UIKit

protocol AddCellDelegate {
    func addCellTextDidChanged(cell: AddCell, text: String?)
}

class AddCell: UITableViewCell {
    
    var delegate: AddCellDelegate?
    
    @IBOutlet weak var addTodoTextField: UITextField!
    
    @IBAction func addTodoTextFieldTextDidChanged(_ sender: UITextField) {
        delegate?.addCellTextDidChanged(cell: self, text: sender.text)
    }

}
