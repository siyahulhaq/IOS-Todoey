//
//  TodoViewController.swift
//  Todoey
//
//  Created by Siyahul Haq on 14/08/22.
//

import UIKit

class TodoViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeItems = defaults.object(forKey: "Todos") as? [String] {
            items = safeItems
        }
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //Mark: Table View delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCellView",for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    //Mark: Onselect row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellForRow = tableView.cellForRow(at: indexPath)
        if cellForRow?.accessoryType == .checkmark {
            cellForRow?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    //Mark: Add new Item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Todo", message: "Here you can add todo", preferredStyle: .alert)
        
        var textField: UITextField?
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            print("Added")
            if let safeTextField = textField {
                self.items.append(safeTextField.text!)
                self.defaults.set(self.items, forKey: "Todos")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

