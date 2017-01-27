//
//  ViewController.swift
//  MyTodoList
//
//  Created by otukutun on 1/26/17.
//  Copyright © 2017 otukutun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var todoList = [MyTodo]()
    
    @IBAction func tapAddButton(_ sender: Any) {
        let alertController = UIAlertController(title: "TODO追加", message: "TODOを入力してください", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (action:UIAlertAction) in
            
            if let textField = alertController.textFields?.first {
                
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, at: 0)
                
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
                
                let userDefaults = UserDefaults.standard
                
                let data = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
                userDefaults.set(data, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        
        alertController.addAction(okAction)
        
        let cancelButton = UIAlertAction(title: "CANCEL",
                                         style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(with: storedTodoList) as? [MyTodo] {
                todoList.append(contentsOf: unarchiveTodoList)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        let mytodo = todoList[indexPath.row]
        
        cell.textLabel?.text = mytodo.todoTitle
        
        if mytodo.todoDone {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        if myTodo.todoDone {
            myTodo.todoDone = false
        } else {
            myTodo.todoDone = true
        }
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            todoList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            let data:Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        }
    }
}

