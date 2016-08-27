//
//  ProjectListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/26/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ProjectListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetch = NSFetchRequest(entityName: fetches.Projects.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "startDate", ascending: false)
    fetch.sortDescriptors = [primarySortDesc]
    
    let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
    frc.delegate = self
    
    return frc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
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
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let current = sections[section]
      return current.numberOfObjects
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as! ProjectCell
    configureCell(cell, indexPath: indexPath)
    return cell
  }
  
  func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    let project = fetchedResultsController.objectAtIndexPath(indexPath) as! Project
    (cell as! ProjectCell).configureCell(withProject: project)
  }
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    self.tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type {
    case .Update:
      let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as? ProjectCell
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
  
}
