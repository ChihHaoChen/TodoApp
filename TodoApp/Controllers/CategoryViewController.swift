//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by ChihHao on 2018-09-15.
//  Copyright © 2018 ChihHao. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //var categoryArray = [Category]()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet!"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //MARK: - Data Manipulation Methods
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
//            self.categoryArray.append(newCategory) // since results container is an auto-updated container, so we don't need to use "append"
            
            self.saveCategories(category: newCategory)
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "create new category"
            textField = alertTexField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow    {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK - Data Manupulation Methods
    func saveCategories(category: Category)    {
        do  {
            try realm.write {
                realm.add(category)
            }
        }   catch   {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()    {
        categories = realm.objects(Category.self)
       
        tableView.reloadData()
    }
}
