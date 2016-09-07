//
//  ProjectDetailVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/6/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ProjectDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SaveDelegateData, UIScrollViewDelegate {
  
  var project: Project? = nil
  var taskData: [Task]?
  let dateFormatter = NSDateFormatter()
  var imagePickerController: UIImagePickerController!
  var dueDate: NSDate!
  let imagePickerButtonHeight: CGFloat = 200
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var costFld: UITextField!
  @IBOutlet weak var detailsFld: UITextView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var selectPhoto: UIButton!
  @IBOutlet weak var selectDueDate: UIButton!
  @IBOutlet weak var photoBtnHeight: NSLayoutConstraint!
  @IBOutlet weak var taskTableHeight: NSLayoutConstraint!
  @IBOutlet weak var newTaskBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
    
    scrollView.delegate = self
    
    let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
    tapGest.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGest)
    
    detailsFld.layer.borderColor = UIColor.blackColor().CGColor
    detailsFld.layer.borderWidth = 1.0
    
    tableView.delegate = self
    tableView.dataSource = self
    
    dateFormatter.dateFormat = "M/d/yy"
    taskTableHeight.constant = 0
    
    if project == nil {
      self.navigationItem.title = "New project"
      selectPhoto.setTitle("Tap to select", forState: .Normal)
      selectDueDate.setTitle("Due date...", forState: .Normal)
      self.newTaskBtn.enabled = false
      self.newTaskBtn.backgroundColor = UIColor.grayColor()
      self.newTaskBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
    
    if let project = self.project {
      
      self.newTaskBtn.enabled = true
      
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
        photoBtnHeight.constant = imagePickerButtonHeight
        selectPhoto.setImage(UIImage(data: photo), forState: .Normal)
      }
      if let tasks = project.taskList where tasks.count > 0 {
        taskTableHeight.constant = 200
        let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
        self.taskData = tasks.sortedArrayUsingDescriptors([primarySortDesc]) as? [Task]
      }
      if let details = project.details {
        detailsFld.text = details
      }
    }
    
  }
  
  func hideKeyboard() {
    self.view.endEditing(true)
  }
  
  func adjustForKeyboard(notification: NSNotification) {
    let userInfo = notification.userInfo!
    
    let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
    
    if notification.name == UIKeyboardWillHideNotification {
      scrollView.contentInset = UIEdgeInsetsZero
    } else {
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
    }
    scrollView.scrollIndicatorInsets = scrollView.contentInset
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
        newProject.dueDate = self.dueDate
        newProject.estimatedTime = Double(timeFld.text!)
        if let photo = selectPhoto.imageView?.image, let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as? Photo {
          newPhoto.data = UIImagePNGRepresentation(photo)
          newProject.photo = newPhoto
        }
      }
    } else {
      
      // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
      project!.title = titleFld.text!
      project!.complete = false
      project!.estimatedCost = Double(costFld.text!)
      project!.details = detailsFld.text
      project!.dueDate = self.dueDate
      project!.estimatedTime = Int(timeFld.text!)
      if let photo = selectPhoto.imageView?.image, let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as? Photo {
        newPhoto.data = UIImagePNGRepresentation(photo)
        project!.photo = newPhoto
      }
    }
    
    do {
      try context.save()
      self.navigationController?.popViewControllerAnimated(true)
    } catch {
      print(error)
    }
    
  }
  
  @IBAction func newTaskPressed(sender: UIButton) {
    print("adding new task")
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDueDatePicker" {
      if let destVC = segue.destinationViewController as? DueDatePickerVC {
        destVC.delegate = self
        destVC.startDate = self.dueDate
      }
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
    if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.selectPhoto.contentMode = .ScaleAspectFill
      self.selectPhoto.setImage(pickedImage, forState: .Normal)
      self.selectPhoto.setTitle("", forState: .Normal)
      self.photoBtnHeight.constant = imagePickerButtonHeight
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
  
  func saveFromDelegate(data: AnyObject) {
    self.dueDate = data as! NSDate
    selectDueDate.setTitle("Due " + dateFormatter.stringFromDate(dueDate), forState: .Normal)
  }
  
}
