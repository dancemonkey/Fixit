//
//  HitListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/9/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class HitListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  let sectionNameKeypath = "sectionName"
  
  var fetchedResultsController: NSFetchedResultsController<Task>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    let fetch = NSFetchRequest<Task>(entityName: fetches.Tasks.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "sectionName", ascending: true)
    let secondarySortDesc = NSSortDescriptor(key: "time", ascending: true)
    let tertiarySortDesc = NSSortDescriptor(key: "creationDate", ascending: false)
    fetch.sortDescriptors = [primarySortDesc,secondarySortDesc, tertiarySortDesc]
    fetch.predicate = NSPredicate(format: "time.intValue <= 15 AND completed.boolValue == false", argumentArray: nil)
    
    fetchedResultsController = NSFetchedResultsController<Task>(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    attemptFetch()
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
    self.tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTaskDetail" {
      if let destVC = segue.destination as? TaskDetailVC {
        destVC.task = fetchedResultsController.object(at: sender as! IndexPath)
      }
    }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "hitListCell", for: indexPath) as! HitListCell
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
    performSegue(withIdentifier: "showTaskDetail", sender: indexPath)
  }
  
  func configureCell(_ cell: HitListCell, indexPath: IndexPath) {
    let task = fetchedResultsController.object(at: indexPath)
    cell.configureCell(withTask: task)
  }

  
  // MARK: FRC Methods
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .update:
      let cell = self.tableView.cellForRow(at: indexPath!) as? HitListCell
      configureCell(cell!, indexPath: indexPath!)
    case .insert:
      self.tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      self.tableView.deleteRows(at: [indexPath!], with: .fade)
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
