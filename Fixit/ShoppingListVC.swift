//
//  ShoppingListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/7/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  let sectionNameKeypath = "sectionName"
  
  var fetchedResultsController: NSFetchedResultsController<Task>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    let fetch = NSFetchRequest<Task>(entityName: fetches.Tasks.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "sectionName", ascending: true)
    let secondarySortDesc = NSSortDescriptor(key: "cost", ascending: true)
    let tertiarySortDesc = NSSortDescriptor(key: "creationDate", ascending: false)
    fetch.sortDescriptors = [primarySortDesc,secondarySortDesc, tertiarySortDesc]
    fetch.predicate = NSPredicate(format: "shoppingList.boolValue == true AND completed.boolValue == false", argumentArray: nil)
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = self
   
  }
  
  func attemptFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("\(error)")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    attemptFetch()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTaskDetail" {
      if let destVC = segue.destination as? TaskDetailVC {
        destVC.task = fetchedResultsController.object(at: sender as! IndexPath)
      }
    }
  }
  
  @IBAction func questionPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Shopping List", message: "This is a list of all tasks that you have flipped the 'shopping cart' switch on in the task detail view. You can tap on a row to go directly to the task detail screen of that item.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  // MARK: Tableview methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return (fetchedResultsController.sections?.count)!
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let current = sections[section]
      return current.numberOfObjects
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListCell
    configureCell(cell, indexPath: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let managedObject = fetchedResultsController.object(at: indexPath)
    appDelegate.managedObjectContext.delete(managedObject)
    do {
      try appDelegate.managedObjectContext.save()
    } catch {
      print("wtf")
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Utils.animateButton(tableView.cellForRow(at: indexPath)!, withTiming: 0.05) {
      self.performSegue(withIdentifier: "showTaskDetail", sender: indexPath)
    }
  }
  
  func configureCell(_ cell: ShoppingListCell, indexPath: IndexPath) {
    let task = fetchedResultsController.object(at: indexPath)
    cell.configureCell(withTask: task)
  }

  // MARK: FRC methods
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .update:
      if let path = indexPath {
        let cell = self.tableView.cellForRow(at: path) as? ShoppingListCell
        configureCell(cell!, indexPath: path)
      }
    case .insert:
      if let newPath = newIndexPath {
        self.tableView.insertRows(at: [newPath], with: .fade)
      }
    case .delete:
      if let path = indexPath {
        self.tableView.deleteRows(at: [path], with: .fade)
      }
    case .move:
      if let deleteIndexPath = indexPath {
        self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
      }
      if let insertIndexPath = newIndexPath {
        self.tableView.insertRows(at: [insertIndexPath], with: .fade)
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.endUpdates()
  }
  
}
