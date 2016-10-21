//
//  ProjectListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/26/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

enum ProjectSorts: String {
  case title, dueDate, estimatedCost, estimatedTime
}

class ProjectListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var customSortString: ProjectSorts = ProjectSorts.dueDate
  var primarySortDesc: NSSortDescriptor!
  var secondarySortDesc: NSSortDescriptor!
  
  var fetchedResultsController: NSFetchedResultsController<Project>!
  
  let prefs = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setFRC()
    attemptFetch()
  }
  
  func attemptFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("\(error)")
    }
  }
  
  func setSortDescriptors() {
    if let sortString = prefs.value(forKey: "projectSortString") as? String {
      customSortString = ProjectSorts(rawValue: sortString)!
    }
    primarySortDesc = NSSortDescriptor(key: customSortString.rawValue, ascending: true)
    switch customSortString {
    case .title:
      secondarySortDesc = NSSortDescriptor(key: ProjectSorts.dueDate.rawValue, ascending: true)
    case .dueDate:
      secondarySortDesc = NSSortDescriptor(key: ProjectSorts.title.rawValue, ascending: true)
    case .estimatedCost, .estimatedTime:
      secondarySortDesc = NSSortDescriptor(key: ProjectSorts.dueDate.rawValue, ascending: true)
    }
  }
  
  func setFRC() {
    let fetch = NSFetchRequest<Project>(entityName: fetches.Projects.rawValue)
    setSortDescriptors()
    let tertiarySortDescr = NSSortDescriptor(key: "startDate", ascending: true)
    fetch.sortDescriptors = [primarySortDesc, secondarySortDesc, tertiarySortDescr]
    self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self

  }
  
  @IBAction func sortPressed(sender: UIButton) {
    let alert = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
    let project = UIAlertAction(title: "Project title (a->z)", style: .default, handler: sort(sender: ))
    let cost = UIAlertAction(title: "Due date (now->later)", style: .default, handler: sort(sender: ))
    let time = UIAlertAction(title: "Estimated cost ($->$$$)", style: .default, handler: sort(sender: ))
    let title = UIAlertAction(title: "Estimated time (less->more)", style: .default, handler: sort(sender: ))
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(project)
    alert.addAction(cost)
    alert.addAction(time)
    alert.addAction(title)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  func sort(sender: UIAlertAction) {
    switch sender.title! {
    case "Project title (a->z)":
      self.customSortString = .title
      prefs.set(ProjectSorts.title.rawValue, forKey: "projectSortString")
    case "Due date (now->later)":
      self.customSortString = .dueDate
      prefs.set(ProjectSorts.dueDate.rawValue, forKey: "projectSortString")
    case "Estimated cost ($->$$$)":
      self.customSortString = .estimatedCost
      prefs.set(ProjectSorts.estimatedCost.rawValue, forKey: "projectSortString")
    case "Estimated time (less->more)":
      self.customSortString = .estimatedTime
      prefs.set(ProjectSorts.estimatedTime.rawValue, forKey: "projectSortString")
    default: break
    }
    self.fetchedResultsController = nil
    setFRC()
    attemptFetch()
    self.tableView.reloadData()
  }
  
  @IBAction func filterPressed(sender: UIButton) {
    
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
