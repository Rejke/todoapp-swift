//
//  JSONableProtocol.swift
//  TodoApp
//
//  Created by Valery Smirnov on 25/07/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONableProtocol {
    init?(parameter: JSON)
}
