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
    var category: Category? {
        didSet {
            loadItems()
        }
    }
    
    let datatFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //MARK: - Load Items from Plist
    
    func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        if let safeCategory = category {
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", safeCategory.name!)
            if let safePredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, safePredicate])
            } else {
                request.predicate = categoryPredicate;
            }
            do {
                self.items = try self.context.fetch(request)
                print(self.items)
            } catch {
                print("Error fetching data from db \(error)")
            }
            tableView.reloadData()
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
//        context.delete(item)
//        items.remove(at: indexPath.row)
        self.saveItem()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Delete Item
    
    func deleteItem(index: Int) {
        context.delete(items[index])
        items.remove(at: index)
        self.saveItem()
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
                item.parentCategory = self.category
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

//MARK: - Search Bar Methods

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar,_ shouldDismissKb: Bool = true) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        if searchBar.text! != "" {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            loadItems(with: request, predicate: predicate)
        }
        if shouldDismissKb {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            self.searchBarSearchButtonClicked(searchBar, false)
        }
    }

}

