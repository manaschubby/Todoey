//
//  ViewController.swift
//  Todoey
//
//  Created by Manas Ashwin on 03/04/18.
//  Copyright © 2018 Manas Producers. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let item = Item()
        item.title = "Find Mike"
        itemArray.append(item)
       
        
        

    }

    // ///////////////////////
    //MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = (alert.textFields?.first?.text!)!
            self.itemArray.append(newItem)
            

            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}

