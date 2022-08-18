//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Siyahul Haq on 18/08/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories: [Category] = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }
    
    @IBAction func addActionClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "Here you can add Category", preferredStyle: .alert)
        
        var textField: UITextField?
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            if let safeTextField = textField {
                let category = Category(context: self.context)
                category.name = safeTextField.text!
                self.categories.append(category)
                self.saveItem()
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("DATABASE writting Error \(error)")
        }
    }
    
    func loadCategories(_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            self.categories = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Fetch category error \(error)")
        }
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellView",for: indexPath)
        cell.textLabel?.text = self.categories[indexPath.row].name
        return cell
    }
    
    // MARK: - Table View Deligate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoViewController
        if let selectedCategory = tableView.indexPathForSelectedRow {
            destination.category = categories[selectedCategory.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    
}
