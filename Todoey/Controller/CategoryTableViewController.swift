//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Manas Ashwin on 09/04/18.
//  Copyright © 2018 Manas Producers. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadItems()

    }
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: TableView DataSource Methods
    
    
    //TODO: CellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCategory", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    //TODO: RowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
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
            self.categoryArray.append(category)
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
//    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do {
//            categoryArray = try context.fetch(request)
//        }catch{
//            print("Error")
//        }
//        tableView.reloadData()
//
//    }
    
}









