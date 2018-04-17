//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Manas Ashwin on 09/04/18.
//  Copyright © 2018 Manas Producers. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

    }
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    //MARK: TableView DataSource Methods
    
    
    //TODO: CellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCategory", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: UIColor(hexString: categoryArray?[indexPath.row].color), returnFlat: true)
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color)
        
        return cell
    }
    
    
    //TODO: RowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    

    //MARK: Data Manupulation Methods
    @IBAction func addButtonPressed(_ sender: Any)
    {
        var textfield : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textfield = textField
            textfield.placeholder = "Add New Category"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let category = Category()
            
            category.name = (textfield.text?.isEmpty)! ? "New Category" : textfield.text!
            category.color = UIColor.randomFlat().hexValue()
            self.save(category: category)
            
           
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func save(category : Category)
    {
        do {
            try realm.write
            {
                realm.add(category)
            }
        }catch{
            print("Error")
        }
        tableView.reloadData()
    }
    func loadItems() {

        categoryArray = realm.objects(Category.self)
        tableView.reloadData()

    }
    
}
//MARK: Extension
extension CategoryTableViewController : SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexpath) in
            
            try! self.realm.write {
                self.realm.delete((self.categoryArray?[indexPath.row])!)
            }
           
            
        }
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

}









