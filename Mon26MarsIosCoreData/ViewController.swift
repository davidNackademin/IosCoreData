//
//  ViewController.swift
//  Mon26MarsIosCoreData
//
//  Created by David Svensson on 2018-03-26.
//  Copyright © 2018 David Svensson. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    var items: [NSManagedObject] = []
    
    let itemEntityName = "ShoppingItem"
    let cellIdentifier = "CellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        storeShoppingItem(name: "majs", done: false)
//        storeShoppingItem(name: "ärtor", done: false)
//       storeShoppingItem(name: "päron", done: false)
        
//        getShoppingItem()
//        clearShoppingItems()
        getShoppingItem()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = item.value(forKey: "name") as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func storeShoppingItem(name: String, done: Bool) {
        let context = getContext()
        
        if let entity = NSEntityDescription.entity(forEntityName: itemEntityName, in: context) {
            let item = NSManagedObject(entity: entity, insertInto: context)
            item.setValue(name, forKey: "name")
            item.setValue(done, forKey: "completed")
            
            do {
                try context.save()
                items.append(item)
                tableView.reloadData()
                print("Saved!")
            } catch let error as NSError {
                print("Save error: \(error)")
            }
        }
    }
    
    func getShoppingItem() {
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: itemEntityName)
        
        do {
            let searchResult = try context.fetch(fetchRequest)
            
            print("Number of objects: \(searchResult.count)")
            
            for item in searchResult {
                print("\(item.value(forKey: "name"))")
            }
            
            items = searchResult
          
            
        } catch {
            print ("Error loading data")
        }
    }
  
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Item", message: "Add a new Shoppingitem", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "save", style: .default) {
            (action) in
            let textField = alert.textFields?.first
            let itemNameToSave = textField?.text
            
            self.storeShoppingItem(name: itemNameToSave!, done: false)
        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
    
    @IBAction func clearShoppingItems(_ sender: UIBarButtonItem ) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: itemEntityName)
        let context = getContext()
        
        do {
            let searchResult = try context.fetch(fetchRequest)
            
            for item in searchResult {
                context.delete(item)
            }
        } catch {
            print("error reading data")
        }
        
        do {
            try context.save()
            items = []
            tableView.reloadData()
        } catch {
            print("error saving data")
        }
    }
    
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}

