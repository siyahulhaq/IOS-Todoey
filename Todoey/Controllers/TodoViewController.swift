//
//  TodoViewController.swift
//  Todoey
//
//  Created by Siyahul Haq on 14/08/22.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    var items = [TodoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        do {
            self.items = try self.context.fetch(request)
        } catch {
            print("Error fetching data from db \(error)")
        }
    }
    
    //MARK: - Save or Update item
    
    func saveItem() {
        do {
            try context.save()
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
                let item = TodoItem(context: self.context)
                item.done = false
                item.title = safeTextField.text!
                self.items.append(item)
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

