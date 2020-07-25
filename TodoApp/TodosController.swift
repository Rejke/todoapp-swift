//
//  TodosController.swift
//  TodoApp
//
//  Created by Valery Smirnov on 27/06/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TodosController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var projects: [Project] = []
    
    var todos = [["Feed entire family"], ["Finish things"], ["Eat potato"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("https://nameless-dawn-11100.herokuapp.com/api/projects").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar.to(type: Project.self) {
                    self.projects = resData as! [Project]
                }
                if self.projects.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1).cgColor
        cell?.textLabel?.text = projects[section].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        cell.textOfLabel = todos[indexPath.section][indexPath.row]
        cell.checked = false
        return cell
    }
}

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONableProtocol.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(parameter: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}
