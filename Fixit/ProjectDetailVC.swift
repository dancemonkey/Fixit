//
//  ProjectDetailVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/6/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ProjectDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var project: Project? = nil
  var taskData: [Task]?
  let dateFormatter = NSDateFormatter()
  var imagePickerController: UIImagePickerController!
  var dueDate: NSDate! // set this with a delegate after picking it from the date picker popup not yet implemented
  
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var costFld: UITextField!
  @IBOutlet weak var detailsFld: UITextView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var selectPhoto: UIButton!
  @IBOutlet weak var selectDueDate: UIButton!
  @IBOutlet weak var photoBtnHeight: NSLayoutConstraint!
  @IBOutlet weak var taskTableHeaderLbl: UILabel!
  @IBOutlet weak var taskTableHeight: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    dateFormatter.dateFormat = "M/d"
    taskTableHeight.constant = 5
    taskTableHeaderLbl.text = "No tasks yet"
    
    if project == nil {
      self.navigationItem.title = "New project"
      selectPhoto.setTitle("Tap to select", forState: .Normal)
      selectDueDate.setTitle("Due date...", forState: .Normal)
    }
    
    if let project = self.project {
      
      self.navigationItem.title = project.title
      
      if let title = project.title {
        titleFld.text = title
      }
      if let time = project.estimatedTime {
        timeFld.text = String(time)
      }
      if let cost = project.estimatedCost {
        costFld.text = String(cost)
      }
      if let dueDate = project.dueDate {
        selectDueDate.setTitle("Due " + dateFormatter.stringFromDate(dueDate), forState: .Normal)
        self.dueDate = dueDate
      }
      if let photo = project.photo?.data {
        selectPhoto.setTitle("View photo", forState: .Normal)
        photoBtnHeight.constant = 150
        selectPhoto.setImage(UIImage(data: photo), forState: .Normal)
      }
      if let tasks = project.taskList where tasks.count > 0 {
        taskTableHeaderLbl.text = "Tasks"
        taskTableHeight.constant = 200
        let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
        self.taskData = tasks.sortedArrayUsingDescriptors([primarySortDesc]) as? [Task]
      }
      if let details = project.details {
        detailsFld.text = details
      }
    }
    
  }
  
  @IBAction func selectDueDatePressed(sender: UIButton) {
    
  }
  
  @IBAction func savePressed(sender: UIBarButtonItem) {
    let context = appDelegate.managedObjectContext
    
    let formatter = NSNumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .CurrencyStyle
    formatter.locale = .currentLocale()
    
    if project == nil {
      if let newProject = NSEntityDescription.insertNewObjectForEntityForName("Project", inManagedObjectContext: context) as? Project {
        
        // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
        newProject.title = titleFld.text!
        newProject.complete = false
        newProject.estimatedCost = Double(costFld.text!)
        newProject.details = detailsFld.text
        newProject.dueDate = dateFormatter.dateFromString((selectDueDate.titleLabel?.text)!)
        newProject.estimatedTime = Double(timeFld.text!)
      }
    } else {
      
      // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
      project!.title = titleFld.text!
      project!.complete = false
      project!.estimatedCost = Double(costFld.text!)
      project!.details = detailsFld.text
      project!.dueDate = dateFormatter.dateFromString((selectDueDate.titleLabel?.text)!)
      project!.estimatedTime = Int(timeFld.text!)
    }
    
    do {
      try context.save()
      self.navigationController?.popViewControllerAnimated(true)
    } catch {
      print(error)
    }
    
  }
  
  // MARK: Image Picker Methods
  
  @IBAction func selectPhotoPressed(sender: UIButton) {
    imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    imagePickerController.sourceType = .PhotoLibrary
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      self.selectPhoto.contentMode = .ScaleAspectFit
      self.selectPhoto.setImage(pickedImage, forState: .Normal)
      self.selectPhoto.setTitle("", forState: .Normal)
      self.photoBtnHeight.constant = 150
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // MARK: Tableview methods
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let tasks = taskData {
      return tasks.count
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let tasks = taskData, let cell = tableView.dequeueReusableCellWithIdentifier("miniTaskCell") {
      cell.textLabel?.text = tasks[indexPath.row].title
      cell.detailTextLabel?.text = dateFormatter.stringFromDate(tasks[indexPath.row].dueDate!)
      return cell
    }
    return UITableViewCell()
  }
  
}
