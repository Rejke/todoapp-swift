//
//  Project.swift
//  TodoApp
//
//  Created by Valery Smirnov on 24/07/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONable {
    init?(parameter: JSON)
}

class Project: JSONable {
    var id: Int
    var title: String
    
    required init(parameter: JSON){
        id = parameter["id"].intValue
        title = parameter["title"].stringValue
    }
}