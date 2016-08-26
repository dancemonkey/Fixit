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
    let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: false)
    let secondarySortDesc = NSSortDescriptor(key: "title", ascending: true)
    fetch.sortDescriptors = [primarySortDesc, secondarySortDesc]
    
    let frc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
    frc.delegate = self
    
    return frc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("\(error)")
    }
    
  }
  
  @IBAction func addNewPressed(sender: UIBarButtonItem) {
    
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
    let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath)
    let project = fetchedResultsController.objectAtIndexPath(indexPath) as! Project
    cell.textLabel?.text = project.title
    cell.detailTextLabel?.text = String(project.dueDate)
    
    return cell
  }
  
}
