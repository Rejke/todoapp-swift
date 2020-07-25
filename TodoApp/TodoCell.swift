//
//  TodoCell.swift
//  TodoApp
//
//  Created by Valery Smirnov on 28/06/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import UIKit
import M13Checkbox

class TodoCell: UITableViewCell {

    var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkBox: M13Checkbox!
    
    @IBAction func onValueChanged(_ sender: M13Checkbox) {
        let lCheckState: M13Checkbox.CheckState = checked! ? .checked : .unchecked
        
        if sender.checkState != lCheckState {
            checked = !(checked!)
        }
    }
    
    var checked: Bool? {
        didSet {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: textOfLabel!)
            
            if checked == true {
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                label.text = ""
                label.attributedText = attributeString
            } else {
                label.attributedText = nil
                label.text = textOfLabel
            }
        }
    }
    
    var textOfLabel: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.boxType = .square
        checkBox.stateChangeAnimation = .fill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
