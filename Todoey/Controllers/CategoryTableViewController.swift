//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by David Goodman on 10/8/18.
//  Copyright © 2018 David Goodman. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categories : [Category] = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row];
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
//        saveCategories()
//        tableView.reloadData()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add", message: "Add new todoey Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            let category = Category(context: self.context)
            category.name = textField.text!
            
            self.categories.append(category)
            
            self.saveCategories()
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Create new todoey"
            textField = UITextField
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error \(error)")
        }
    }
}
