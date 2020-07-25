//
//  Todo.swift
//  TodoApp
//
//  Created by Valery Smirnov on 25/07/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Todo: JSONableProtocol {
    var id: Int
    var text: String
    var isCompleted: Bool
    var projectId: Int
    
    required init(parameter: JSON) {
        id = parameter["id"].intValue
        text = parameter["text"].stringValue
        isCompleted = parameter["is_completed"].boolValue
        projectId = parameter["project_id"].intValue
    }
}
