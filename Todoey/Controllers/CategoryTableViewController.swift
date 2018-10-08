//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by David Goodman on 10/8/18.
//  Copyright © 2018 David Goodman. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: SwipeTableViewController {
    var categories : Results<Category>?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80

        loadCategories()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row];
        cell.textLabel?.text = category?.name ?? "No Categories added yet"
        
//        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add", message: "Add new todoey Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            let category = Category()
            category.name = textField.text!
            
            self.save(category: category)
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Create new todoey"
            textField = UITextField
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories() {
       categories = realm.objects(Category.self)
       tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("realm delete fail, \(error)")
            }
        }
    }
    
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error \(error)")
        }
    }
}
