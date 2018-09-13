//
//  ViewController.swift
//  TodoApp
//
//  Created by ChihHao on 2018-09-12.
//  Copyright © 2018 ChihHao. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()

    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator => value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none // Used to replace the following code
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else    {
//            cell.accessoryType = .none
//        }
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // this can be used to replace the following code
//        if itemArray[indexPath.row].done == false   {
//            itemArray[indexPath.row].done = true
//        }
//        else    {
//            itemArray[indexPath.row].done = false
//        }
        tableView.reloadData()
        saveItems(array: itemArray)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
           
            // Save the data into permanent storage which will be saved in xxx.plist
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            // Since the data is defined through our class, so we have to use encoder to store the data, not the defaults singleton
            self.saveItems(array: self.itemArray)
            
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
    func saveItems(array: [Item])    {
        let encoder = PropertyListEncoder()
        do  {
            let data = try encoder.encode(array)
            try data.write(to: (dataFilePath)!)
        }   catch   {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadItems()    {
        if let data = try? Data(contentsOf: dataFilePath!)  {
            let decoder = PropertyListDecoder()
            do  {
                itemArray = try decoder.decode([Item].self, from: data)
            }   catch   {
                print("Errors in decoding \(error)")
            }
        }
    }

}


