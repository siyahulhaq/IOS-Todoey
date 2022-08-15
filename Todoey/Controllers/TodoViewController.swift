//
//  TodoViewController.swift
//  Todoey
//
//  Created by Siyahul Haq on 14/08/22.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var items = [TodoItem]()
    
    let datatFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //MARK: - Load Items from Plist
    
    func loadItems() {
        if let data = try? Data(contentsOf: datatFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error Decding todo items from plist \(error)")
            }
        }
    }
    
    //MARK: - Save or Update item
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.items)
            if let safeDataFilePath = self.datatFilePath {
                try data.write(to: safeDataFilePath)
            }
        } catch {
            print("DATABASE writting Error \(error)")
        }
    }
    
    //MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCellView",for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row].title
        let item = items[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - Onselect row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        item.done = !item.done
        self.saveItem()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Todo", message: "Here you can add todo", preferredStyle: .alert)
        
        var textField: UITextField?
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            print("Added")
            if let safeTextField = textField {
                self.items.append(TodoItem(title: safeTextField.text!, done: false))
                self.saveItem()
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

