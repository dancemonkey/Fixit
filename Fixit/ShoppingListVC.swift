//
//  ShoppingListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/7/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

enum ShoppingListSorts: String {
  case parentProjectTitle, title, cost
}

class ShoppingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var customSortString: ShoppingListSorts = .parentProjectTitle
  
  var fetchedResultsController: NSFetchedResultsController<Task>!
  var primarySortDesc: NSSortDescriptor!
  var secondarySortDesc: NSSortDescriptor!
  
  let prefs = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  
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
    setFRC()
    attemptFetch()
  }
  
  func setSortDescriptors() {
    if let sortString = prefs.value(forKey: "shoppingListSortString") as? String {
      customSortString = ShoppingListSorts(rawValue: sortString)!
    }
    primarySortDesc = NSSortDescriptor(key: customSortString.rawValue, ascending: true)
    switch customSortString {
    case .parentProjectTitle:
      secondarySortDesc = NSSortDescriptor(key: "cost", ascending: true)
    case .title:
      secondarySortDesc = NSSortDescriptor(key: "parentProjectTitle", ascending: true)
    case .cost:
      secondarySortDesc = NSSortDescriptor(key: "parentProjectTitle", ascending: true)
    }
  }
  
  func setFRC() {
    let fetch = NSFetchRequest<Task>(entityName: fetches.Tasks.rawValue)
    setSortDescriptors()
    let tertiarySortDesc = NSSortDescriptor(key: "creationDate", ascending: false)
    fetch.sortDescriptors = [primarySortDesc,secondarySortDesc, tertiarySortDesc]
    fetch.predicate = NSPredicate(format: "shoppingList.boolValue == true AND completed.boolValue == false", argumentArray: nil)
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = self
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
  
  @IBAction func sortPressed(sender: UIButton) {
    let alert = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
    let project = UIAlertAction(title: "Project title", style: .default, handler: sort(sender: ))
    let title = UIAlertAction(title: "Task title", style: .default, handler: sort(sender: ))
    let cost = UIAlertAction(title: "Estimated cost", style: .default, handler: sort(sender: ))
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(project)
    alert.addAction(title)
    alert.addAction(cost)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func filterPressed(sender: UIButton) {
    
  }
  
  func sort(sender: UIAlertAction) {
    switch sender.title! {
    case "Project title":
      self.customSortString = .parentProjectTitle
      prefs.set(ShoppingListSorts.parentProjectTitle.rawValue, forKey: "shoppingListSortString")
    case "Task title":
      self.customSortString = .title
      prefs.set(ShoppingListSorts.title.rawValue, forKey: "shoppingListSortString")
    case "Estimated cost":
      self.customSortString = .cost
      prefs.set(ShoppingListSorts.cost.rawValue, forKey: "shoppingListSortString")
    default: break
    }
    self.fetchedResultsController = nil
    setFRC()
    attemptFetch()
    self.tableView.reloadData()
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
