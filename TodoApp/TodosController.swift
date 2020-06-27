//
//  TodosController.swift
//  TodoApp
//
//  Created by Valery Smirnov on 27/06/2020.
//  Copyright © 2020 Valery Smirnov. All rights reserved.
//

import UIKit

class TodosController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var projects = ["Family", "Work", "Other"]
    var todos = [["Feed entire family"], ["Finish things"], ["Eat potato"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //http://stackoverflow.com/questions/31693901/design-uitableviews-section-header-in-interface-builder
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")
        cell?.backgroundColor = UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 1)
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1).cgColor
        cell?.textLabel?.text = projects[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")
        cell?.textLabel?.text = todos[indexPath.section][indexPath.row]
        return cell!
    }
}
