//
//  ViewController.swift
//  Todoey
//
//  Created by Manas Ashwin on 03/04/18.
//  Copyright © 2018 Manas Producers. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: UITableViewController, UISearchBarDelegate {

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    var todoItems : Results<Item>?
    let realm = try! Realm()
    @IBOutlet var searchBar : UISearchBar!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        loadItems()
        title = selectedCategory?.name
        tableView.separatorStyle = .none
        navigationController?.navigationBar.tintColor = ContrastColorOf(backgroundColor:  UIColor(hexString: selectedCategory?.color), returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(backgroundColor:  UIColor(hexString: selectedCategory?.color), returnFlat: true)]
        searchBar.barTintColor = UIColor(hexString: selectedCategory?.color)
        navigationController?.navigationBar.barTintColor = UIColor(hexString: selectedCategory?.color)
        
    }

    // ///////////////////////
    //MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.backgroundColor = UIColor(hexString: selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: cell.backgroundColor!, returnFlat: true)
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveData()
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error saving Done status \(error)")
            }
        }
        
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
            do{
                if let category = self.selectedCategory
                {
                
                    try self.realm.write
                    {
                        let newItem = Item()
                        newItem.title = (alert.textFields?.first?.text!)!
                        
                        category.items.append(newItem)
                    }
                
                    self.todoItems = self.selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
                    self.tableView.reloadData()
                }
            } catch
            {
                print("Error Saving Items")
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Model Manupalation Methods
    
    
    func loadItems()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
}

//MARK: Extension for Search Bar Methods

extension TodoListViewController{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.endEditing(true)
            }
        }

    }
}

extension TodoListViewController : SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        
        guard orientation == .right else {
            return  nil
        }
        
        let action = SwipeAction(style: .destructive, title: "Delete") { (action, indexpath) in
            try! self.realm.write {
                self.realm.delete((self.todoItems?[indexPath.row])!)
                
            }
            
        }
        
        return [action]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var option = SwipeTableOptions()
        
        option.expansionStyle = .destructive
        
        return option
    }
    
}












