//
//  TaskListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/31/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TaskListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  let sectionNameKeyPath = "completed"
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetch = NSFetchRequest(entityName: fetches.Tasks.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
    let secondarySortDesc = NSSortDescriptor(key: "completed", ascending: true)
    fetch.sortDescriptors = [secondarySortDesc ,primarySortDesc]
    
    let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: self.sectionNameKeyPath, cacheName: nil)
    
    frc.delegate = self
    
    return frc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    attemptFetch()
  }
  
  func attemptFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("\(error)")
    }
  }
  
  @IBAction func addNewPressed(sender: UIBarButtonItem) {
    performSegueWithIdentifier("createNewTask", sender: self)
  }
  
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
    let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskCell
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
    return 100
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sections = fetchedResultsController.sections {
      let currentSection = sections[section]
      if currentSection.name == "0" {
        return "Incomplete"
      } else {
        return "Complete"
      }
    }
    return nil
  }
  
  func configureCell(cell: TaskCell, indexPath: NSIndexPath) {
    let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
    cell.configureCell(withTask: task)
  }
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    self.tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type {
    case .Update:
      let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as? TaskCell
      configureCell(cell!, indexPath: indexPath!)
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
