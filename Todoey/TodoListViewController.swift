//
//  ViewController.swift
//  Todoey
//
//  Created by Manas Ashwin on 03/04/18.
//  Copyright © 2018 Manas Producers. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["FindMike", "buy eggs", "Destroy Demogorgon"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [String]
        {
            itemArray = items
        }
    }

    // ///////////////////////
    //MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append((alert.textFields?.first?.text!)!)
            
            UserDefaults.standard.setValue(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}

