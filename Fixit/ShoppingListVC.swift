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
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetch = NSFetchRequest(entityName: fetches.Tasks.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "sectionName", ascending: true)
    let secondarySortDesc = NSSortDescriptor(key: "title", ascending: true)
    let tertiarySortDesc = NSSortDescriptor(key: "creationDate", ascending: false)
    fetch.sortDescriptors = [primarySortDesc,secondarySortDesc]
    fetch.predicate = NSPredicate(format: "shoppingList.boolValue == true AND completed.boolValue == false", argumentArray: nil)
    
    let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: self.sectionNameKeypath, cacheName: nil)
    
    frc.delegate = self
    
    return frc
  }()
  
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    attemptFetch()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTaskDetail" {
      if let destVC = segue.destinationViewController as? TaskDetailVC {
        destVC.task = fetchedResultsController.objectAtIndexPath(sender as! NSIndexPath) as? Task
      }
    }
  }
  
  // MARK: Tableview methods
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return (fetchedResultsController.sections?.count)!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let current = sections[section]
      return current.numberOfObjects
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("shoppingListCell", forIndexPath: indexPath) as! ShoppingListCell
    configureCell(cell, indexPath: indexPath)
    return cell
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    let managedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
    appDelegate.managedObjectContext.deleteObject(managedObject)
    do {
      try appDelegate.managedObjectContext.save()
    } catch {
      print("wtf")
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sections = fetchedResultsController.sections {
      let currentSection = sections[section]
      return currentSection.name
    } else {
      return "No project"
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("showTaskDetail", sender: indexPath)
  }
  
  func configureCell(cell: ShoppingListCell, indexPath: NSIndexPath) {
    let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
    cell.configureCell(withTask: task)
  }

  // MARK: FRC methods
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    self.tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type {
    case .Update:
      if let path = indexPath {
        let cell = self.tableView.cellForRowAtIndexPath(path) as? ShoppingListCell
        configureCell(cell!, indexPath: path)
      }
    case .Insert:
      self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
    case .Delete:
      self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
    case .Move:
      if let deleteIndexPath = indexPath {
        self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
      }
      if let insertIndexPath = newIndexPath {
        self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
      }
    }
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.tableView.endUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    switch type {
    case .Insert:
      self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    case .Delete:
      self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    case .Move:
      break
    case .Update:
      break
    }
  }
  
}
