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
import CommonCrypto

class TodosController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var projects: [Project] = []
    var lastResultMD5: Data? = nil
    var requestResult = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProjectsAPI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentSegue" {
            if let destVC = (segue.destination as! UINavigationController).topViewController as? AddTodoController {
                destVC.projects = self.projects
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
        return self.projects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        return self.projects[section].todos.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1).cgColor
        cell?.textLabel?.text = self.projects[section].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        cell.todoId = self.projects[indexPath.section].todos[indexPath.row].id
        cell.projectId = self.projects[indexPath.section].todos[indexPath.row].projectId
        cell.textOfLabel = self.projects[indexPath.section].todos[indexPath.row].text
        cell.checkBox.checkState = self.projects[indexPath.section].todos[indexPath.row].isCompleted ? .checked : .unchecked
        cell.checked = self.projects[indexPath.section].todos[indexPath.row].isCompleted
        return cell
    }
    
    func getProjectsAPI() {
        Alamofire.request("https://nameless-dawn-11100.herokuapp.com/api/projects").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar.to(type: Project.self) {
                    self.projects = resData as! [Project]
                }
            }
        }
        
        var todos: [Todo] = []
        
        Alamofire.request("https://nameless-dawn-11100.herokuapp.com/api/todo").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                self.lastResultMD5 = self.MD5(string: swiftyJsonVar.rawString()!)
                if let resData = swiftyJsonVar.to(type: Todo.self) {
                    todos = resData as! [Todo]
                }
                
                if todos.count > 0 {
                    for todo in todos {
                        if todo.projectId == self.projects[todo.projectId - 1].id {
                            self.projects[todo.projectId - 1].todos.append(todo)
                        } else {
                            for i in todo.projectId...(self.projects.count - 1) {
                                if todo.projectId == self.projects[i].id {
                                    self.projects[i].todos.append(todo)
                                    break
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func needUpdateAPI() -> Bool {
        Alamofire.request("https://nameless-dawn-11100.herokuapp.com/api/todo").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if self.lastResultMD5 != self.MD5(string: swiftyJsonVar.rawString()!) {
                    self.requestResult = true
                }
            }
        }
        return self.requestResult
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if needUpdateAPI() {
            getProjectsAPI()
        }
    }
    
    func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
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
