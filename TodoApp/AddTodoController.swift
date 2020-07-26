//
//  AddTodoController.swift
//  TodoApp
//
//  Created by Valery Smirnov on 05/07/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddTodoController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tfParent: UIView!
    
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfParent.layer.borderWidth = 1
        tfParent.layer.borderColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1).cgColor
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectCell
        
        cell.label.text = projects[indexPath.row].title
        cell.tag = projects[indexPath.row].id
        
        return cell
    }
    
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        if tableView.indexPathForSelectedRow == nil {
            return
        }
        
        let selectedCell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as UITableViewCell?
        
        if textField!.text!.isEmpty {
            return
        }
        
        if let jsonData = try? JSON(["text": textField!.text!, "is_completed": false, "project_id": selectedCell!.tag]).rawData() {
            
            var request = URLRequest(url: URL(string: "https://nameless-dawn-11100.herokuapp.com/api/todo/create")!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            Alamofire.request(request).responseString { response in
                if response.result.error == nil {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
