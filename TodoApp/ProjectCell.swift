//
//  ProjectCell.swift
//  TodoApp
//
//  Created by Valery Smirnov on 10/07/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
