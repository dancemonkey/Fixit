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
  
  let sectionNameKeyPath = "dueDate"
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetch = NSFetchRequest(entityName: fetches.Tasks.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
    fetch.sortDescriptors = [primarySortDesc]
    
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
    performSegueWithIdentifier("createNew", sender: self)
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return (fetchedResultsController.sections?.count)!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sections = fetchedResultsController.sections! as [NSFetchedResultsSectionInfo]
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath)
    configureCell(cell, indexPath: indexPath)
    return UITableViewCell()
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
    //cell.configureCell(withProject: task)
  }
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    self.tableView.beginUpdates()
  }
  
//  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//    switch type {
//    case .Update:
//      let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as? TaskCell
//      configureCell(cell!, indexPath: indexPath!)
//    case .Insert:
//      self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//    case .Delete:
//      self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//    case .Move:
//      if let deleteIndexPath = indexPath {
//        self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
//      }
//      if let insertIndexPath = newIndexPath {
//        self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
//      }
//    }
//  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.tableView.endUpdates()
  }

  
}
