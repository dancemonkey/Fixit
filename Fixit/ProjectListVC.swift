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
    print("getting fetchedResultsC")
    let fetch = NSFetchRequest(entityName: fetches.Projects.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: false)
    let secondarySortDesc = NSSortDescriptor(key: "title", ascending: true)
    fetch.sortDescriptors = [primarySortDesc, secondarySortDesc]
    
    let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "title", cacheName: nil)
    
    frc.delegate = self
    
    return frc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      try fetchedResultsController.performFetch()
      print("performed fetch")
    } catch {
      print("\(error)")
    }
    
  }
  
  @IBAction func addNewPressed(sender: UIBarButtonItem) {
    
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let sections = fetchedResultsController.sections {
      print(sections.count)
      return sections.count
    }
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let current = sections[section]
      print(current.numberOfObjects)
      return current.numberOfObjects
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("projectCell")
    let project = fetchedResultsController.objectAtIndexPath(indexPath) as! Project
    cell?.textLabel?.text = project.title
    cell?.detailTextLabel?.text = String(project.dueDate)
    
    return cell!
  }
  
  func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if let sections = fetchedResultsController.sections {
      let current = sections[section]
      return current.name
    }
    return nil
  }
  
}
