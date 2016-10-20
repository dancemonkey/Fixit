//
//  HitListVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/9/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

enum HitListSorts: String {
  case parentProjectTitle, title, time
}

class HitListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  var customSortString: HitListSorts = .parentProjectTitle
    
  var fetchedResultsController: NSFetchedResultsController<Task>!
  var primarySortDesc: NSSortDescriptor!
  var secondarySortDesc: NSSortDescriptor!
  
  let prefs = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self

    //attemptFetch()
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
    setFRC()
    attemptFetch()
  }
  
  func setSortDescriptors() {
    if let sortString = prefs.value(forKey: "hitListSortString") as? String {
      customSortString = HitListSorts(rawValue: sortString)!
    }
    primarySortDesc = NSSortDescriptor(key: customSortString.rawValue, ascending: true)
    switch customSortString {
    case .parentProjectTitle:
      secondarySortDesc = NSSortDescriptor(key: "time", ascending: true)
    case .title:
      secondarySortDesc = NSSortDescriptor(key: "time", ascending: true)
    case .time:
      secondarySortDesc = NSSortDescriptor(key: "parentProjectTitle", ascending: true)
    }
    
  }
  
  func setFRC() {
    let fetch = NSFetchRequest<Task>(entityName: fetches.Tasks.rawValue)
    setSortDescriptors()
    let tertiarySortDesc = NSSortDescriptor(key: "creationDate", ascending: false)
    fetch.sortDescriptors = [primarySortDesc,secondarySortDesc, tertiarySortDesc]
    fetch.predicate = NSPredicate(format: "time.intValue <= 31 AND completed.boolValue == false", argumentArray: nil)
    fetch.sortDescriptors = [primarySortDesc,secondarySortDesc, tertiarySortDesc]
    fetch.predicate = NSPredicate(format: "time.intValue <= 31 AND completed.boolValue == false", argumentArray: nil)
    self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTaskDetail" {
      if let destVC = segue.destination as? TaskDetailVC {
        destVC.task = fetchedResultsController.object(at: sender as! IndexPath)
      }
    }
  }
  
  @IBAction func questionPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Hit List", message: "This is a list of all tasks that have an estimated time (in minutes) entered into the time field, of 30 minutes or less. This way you can get a quick look at all of the tasks you have on your list that won't take you long to complete. \n\n If you have a few minutes to spare and want to get something done on your Fixit List, this is the place to look!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func sortPressed(sender: UIButton) {
    let alert = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
    let project = UIAlertAction(title: "Project title", style: .default, handler: sort(sender: ))
    let title = UIAlertAction(title: "Task title", style: .default, handler: sort(sender: ))
    let time = UIAlertAction(title: "Estimated time", style: .default, handler: sort(sender: ))
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(project)
    alert.addAction(title)
    alert.addAction(time)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func filterPressed(sender: UIButton) {
    
  }
  
  func sort(sender: UIAlertAction) {
    switch sender.title! {
    case "Project title":
      self.customSortString = .parentProjectTitle
      prefs.set(HitListSorts.parentProjectTitle.rawValue, forKey: "hitListSortString")
    case "Task title":
      self.customSortString = .title
      prefs.set(HitListSorts.title.rawValue, forKey: "hitListSortString")
    case "Estimated time":
      self.customSortString = .time
      prefs.set(HitListSorts.time.rawValue, forKey: "hitListSortString")
    default: break
    }
    self.fetchedResultsController = nil
    setFRC()
    attemptFetch()
    self.tableView.reloadData()
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
    Utils.animateButton(tableView.cellForRow(at: indexPath)!, withTiming: 0.05) {
      self.performSegue(withIdentifier: "showTaskDetail", sender: indexPath)
    }
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
