//
//  TaskListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/31/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

enum TaskSorts: String {
  case parentProjectTitle, dueDate, cost, time, title
}

class TaskListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var customSortString: TaskSorts = .dueDate
  var secondarySortDesc: NSSortDescriptor!
  var tertiarySortDesc: NSSortDescriptor!
  
  var fetchedResultsController: NSFetchedResultsController<Task>!
  
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
    
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44.0, right: 0)
  }
  
  func attemptFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("\(error)")
    }
  }
  
  func setSortDescriptors() {
    if let sortString = prefs.value(forKey: "customSortString") as? String {
      customSortString = TaskSorts(rawValue: sortString)!
    }
    secondarySortDesc = NSSortDescriptor(key: customSortString.rawValue, ascending: true)
    tertiarySortDesc = NSSortDescriptor(key: "parentProjectTitle", ascending: true)
    switch customSortString {
    case .parentProjectTitle:
      tertiarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
    case .dueDate:
      tertiarySortDesc = NSSortDescriptor(key: "parentProjectTitle", ascending: true)
    case .cost, .time, .title:
      tertiarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
    }
  }
  
  func setFRC() {
    let fetch = NSFetchRequest<Task>(entityName: fetches.Tasks.rawValue)
    let primarySortDesc = NSSortDescriptor(key: "completed", ascending: true)
    
    setSortDescriptors()
    
    let quaternarySortDesc = NSSortDescriptor(key: "creationDate", ascending: false)
    fetch.sortDescriptors = [primarySortDesc, secondarySortDesc, tertiarySortDesc, quaternarySortDesc]
    
    self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = self
  }
  
  @IBAction func sortPressed(sender: UIButton) {
    let alert = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
    let project = UIAlertAction(title: "Project title (a->z)", style: .default, handler: sort(sender: ))
    let dueDate = UIAlertAction(title: "Task title (a->z)", style: .default, handler: sort(sender: ))
    let cost = UIAlertAction(title: "Due date (now->later)", style: .default, handler: sort(sender: ))
    let time = UIAlertAction(title: "Cost ($->$$$)", style: .default, handler: sort(sender: ))
    let title = UIAlertAction(title: "Estimated time (less->more)", style: .default, handler: sort(sender: ))
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(project)
    alert.addAction(dueDate)
    alert.addAction(cost)
    alert.addAction(time)
    alert.addAction(title)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  func sort(sender: UIAlertAction) {
    switch sender.title! {
    case "Project title (a->z)":
      self.customSortString = .parentProjectTitle
      prefs.set(TaskSorts.parentProjectTitle.rawValue, forKey: "customSortString")
    case "Task title (a->z)":
      self.customSortString = .title
      prefs.set(TaskSorts.title.rawValue, forKey: "customSortString")
    case "Due date (now->later)":
      self.customSortString = .dueDate
      prefs.set(TaskSorts.dueDate.rawValue, forKey: "customSortString")
    case "Cost ($->$$$)":
      self.customSortString = .cost
      prefs.set(TaskSorts.cost.rawValue, forKey: "customSortString")
    case "Estimated time (less->more)":
      self.customSortString = .time
      prefs.set(TaskSorts.time.rawValue, forKey: "customSortString")
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
    performSegue(withIdentifier: "createNewTask", sender: self)
  }
  
  @IBAction func deleteCompletedPressed(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "Confirm", message: "You are about to delete all of your completed tasks!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { (action: UIAlertAction) in
      
      let deleteRequest = NSFetchRequest<Task>(entityName: "Task")
      deleteRequest.predicate = NSPredicate(format: "completed == 1", argumentArray: nil)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: deleteRequest as! NSFetchRequest<NSFetchRequestResult>)
      
      do {
        let _ = try appDelegate.managedObjectContext.execute(batchDeleteRequest) as! NSBatchDeleteResult
        appDelegate.managedObjectContext.reset()
        try self.fetchedResultsController.performFetch()
        self.tableView.reloadData()
      } catch {
        print("\(error)")
      }
      
    }))
    
    self.present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func questionPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Task List", message: "This is the master list of all tasks you have created. From here you can create tasks, delete tasks (by swiping left on the table row), and get a quick glance at the particulars of each task.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
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
    if let sections = fetchedResultsController.sections {
      return sections.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let current = sections[section]
      return current.numberOfObjects
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
    configureCell(cell, indexPath: indexPath)
    cell.tag = (indexPath as NSIndexPath).row
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let managedObject = fetchedResultsController.object(at: indexPath)
      appDelegate.managedObjectContext.delete(managedObject)
      do {
        try appDelegate.managedObjectContext.save()
      } catch {
        print("wtf")
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Utils.animateButton(tableView.cellForRow(at: indexPath)!, withTiming: 0.05) {
      self.performSegue(withIdentifier: "showTaskDetail", sender: indexPath)
    }
  }
  
  func configureCell(_ cell: TaskCell, indexPath: IndexPath) {
    let task = fetchedResultsController.object(at: indexPath)
    cell.configureCell(withTask: task)
  }
  
  // MARK: Fetchedresultscontroller methods
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .update:
      if let ip = indexPath {
        if let cell = self.tableView.cellForRow(at: ip) as? TaskCell {
          configureCell(cell, indexPath: ip)
        }
      }
    case .insert:
      if let nip = newIndexPath {
        self.tableView.insertRows(at: [nip], with: .fade)
      }
    case .delete:
      if let ip = indexPath {
        self.tableView.deleteRows(at: [ip], with: .fade)
      }
    case .move:
      if let ip = indexPath, let nip = newIndexPath {
        tableView.deleteRows(at: [ip], with: .fade)
        tableView.insertRows(at: [nip], with: .fade)
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.endUpdates()
    updateBadge()
  }
  
}
