//
//  ViewController.swift
//  TodoApp
//
//  Created by ChihHao on 2018-09-12.
//  Copyright © 2018 ChihHao. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category?    {
        didSet  {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else {fatalError()}
            
        title = selectedCategory?.name

        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) { // this is a life-cycle method
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {   fatalError("Navigation controller does not exist!") }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else  {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        var cellColor : String = "FFFFFF"
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cellColor = todoItems?[indexPath.row].color ?? "FFFFFF"
            
            //cell.backgroundColor = UIColor(hexString: cellColor)
            cell.backgroundColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            //Ternary operator => value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none // Used to replace the following code
        }
        else    {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do  {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch   {
                print("Error saving done status, \(error)")
            }
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory  {
                do  {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        newItem.color = UIColor.randomFlat.hexValue()
                        currentCategory.items.append(newItem)
                    }
                }
                catch   {
                    print("Error saving new items, \(error)")
                }
            }

            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Crete new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods    
    func loadItems()    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    //MARK = Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemDeleted = self.todoItems?[indexPath.row] {
            do  {
                try self.realm.write {
                    self.realm.delete(itemDeleted)
                }
            }
            catch   {
                print("Error deleting items, \(error)")
            }
        }
    }
}

//MARK: Search bar methods:
extension TodoListViewController: UISearchBarDelegate   {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0   {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            } // make searchBar.resignFirstResponder() into foreground

        }
    }
}



