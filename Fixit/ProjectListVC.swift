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
  
  var fetchedResultsController: NSFetchedResultsController<Project>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let fetch = NSFetchRequest<Project>(entityName: fetches.Projects.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: false)
    let secondarySortDesc = NSSortDescriptor(key: "title", ascending: true)
    let tertiarySortDescr = NSSortDescriptor(key: "startDate", ascending: true)
    fetch.sortDescriptors = [primarySortDesc, secondarySortDesc, tertiarySortDescr]
    
    self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
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
  
  @IBAction func addNewPressed(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "createNewProject", sender: self)
  }
  
  @IBAction func questionPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Project List", message: "This is the master list of all projects you have created. From here you can create projects, delete projects (by swiping left on the table row), and get a quick glance at the particulars of each project.", preferredStyle: .alert)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectCell
    configureCell(cell, indexPath: indexPath)
    cell.tag = (indexPath as NSIndexPath).row
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    let managedObject = fetchedResultsController.object(at: indexPath) 
    
    if let taskList = managedObject.taskList {
      for task in taskList {
        appDelegate.managedObjectContext.delete(task as! NSManagedObject)
      }
    }
    if let photo = managedObject.photo {
      appDelegate.managedObjectContext.delete(photo)
    }
    appDelegate.managedObjectContext.delete(managedObject)
    
    do {
      try appDelegate.managedObjectContext.save()
    } catch {
      print("wtf")
    }
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Utils.animateButton(tableView.cellForRow(at: indexPath)!, withTiming: 0.05) { 
      self.performSegue(withIdentifier: "showProjectDetail", sender: indexPath)
    }
  }
  
  func configureCell(_ cell: ProjectCell, indexPath: IndexPath) {
    let project = fetchedResultsController.object(at: indexPath)
    cell.configureCell(withProject: project)
  }
  
  // MARK: FRC Methods
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .update:
      let cell = self.tableView.cellForRow(at: indexPath!) as? ProjectCell
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showProjectDetail" {
      if let destVC = segue.destination as? ProjectDetailVC {
        destVC.project = fetchedResultsController.object(at: sender as! IndexPath)
      }
    }
  }
}
