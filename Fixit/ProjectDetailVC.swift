  //
  //  ProjectDetailVC.swift
  //  Fixit
  //
  //  Created by Drew Lanning on 9/6/16.
  //  Copyright © 2016 Drew Lanning. All rights reserved.
  //
  
  import UIKit
  import CoreData
  
  class ProjectDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveDelegateData, UIScrollViewDelegate {
    
    var project: Project? = nil
    var taskData: [Task]?
    let dateFormatter = NSDateFormatter()
    var dueDate: NSDate!
    let taskHeightConstant: CGFloat = 200
    var photoHeightConstant: CGFloat = 200
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleFld: UITextField!
    @IBOutlet weak var timeFld: UITextField!
    @IBOutlet weak var costFld: UITextField!
    @IBOutlet weak var detailsFld: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var selectDueDate: UIButton!
    @IBOutlet weak var taskTableHeight: NSLayoutConstraint!
    @IBOutlet weak var newTaskBtn: UIButton!
    @IBOutlet weak var photoBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    
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
      
      if project == nil {
        self.navigationItem.title = "New project"
        selectPhoto.setTitle("Tap to add photo", forState: .Normal)
        selectDueDate.setTitle("Due date...", forState: .Normal)
        self.newTaskBtn.enabled = false
        self.newTaskBtn.backgroundColor = UIColor.grayColor()
        self.newTaskBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        trashBtn.enabled = false
      }
      
      if let project = self.project {
        
        self.newTaskBtn.enabled = true
        trashBtn.enabled = true
        
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
          selectPhoto.setImage(UIImage(data: photo), forState: .Normal)
          selectPhoto.imageView?.contentMode = .ScaleAspectFit
          adjustPhotoHeight()
        }
        if let tasks = project.taskList where tasks.count > 0 {
          taskTableHeight.constant = 200
          refreshTableData(withTasks: tasks)
        }
        if let details = project.details {
          detailsFld.text = details
        }
      }
      
    }
    
    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      if let project = self.project {
        if let tasks = project.taskList where tasks.count > 0 {
          taskTableHeight.constant = taskHeightConstant
          refreshTableData(withTasks: tasks)
        }
      }
      if selectPhoto.imageView?.image != nil {
        adjustPhotoHeight()
      }
      self.tableView.reloadData()
    }
    
    @IBAction func deleteCompletedPressed(sender: UIBarButtonItem) {
      
      let alert = UIAlertController(title: "Confirm", message: "You are about to delete this project!", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "Okay", style: .Destructive, handler: { (action: UIAlertAction) in
        
        appDelegate.managedObjectContext.deleteObject(self.project!)
        self.navigationController?.popViewControllerAnimated(true)
        
      }))
      
      self.presentViewController(alert, animated: true, completion: nil)
      
    }
    
    func refreshTableData(withTasks tasks: NSSet) {
      let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
      self.taskData = (tasks.sortedArrayUsingDescriptors([primarySortDesc]) as? [Task])?.filter{ (task: Task) -> Bool in
        return task.completed == false
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
    
    func saveFromDelegate(data: AnyObject) {
      if data is NSDate {
        self.dueDate = data as! NSDate
        selectDueDate.setTitle("Due " + dateFormatter.stringFromDate(dueDate), forState: .Normal)
      } else if data is UIImage {
        selectPhoto.setImage(data as? UIImage, forState: .Normal)
      }
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
        project!.estimatedTime = Double(timeFld.text!)
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
    
    func adjustPhotoHeight() {
      photoBtnHeight.constant = photoHeightConstant
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "showDueDatePicker" {
        if let destVC = segue.destinationViewController as? DueDatePickerVC {
          destVC.delegate = self
          destVC.startDate = self.dueDate
        }
      } else if segue.identifier == "createNewTask" {
        if let destVC = segue.destinationViewController as? TaskDetailVC {
          destVC.project = self.project
        }
      } else if segue.identifier == "showTaskDetail" {
        if let destVC = segue.destinationViewController as? TaskDetailVC {
          destVC.task = self.taskData![(sender as! NSIndexPath).row]
        }
      } else if segue.identifier == "showPhotoDetail" {
        if let destVC = segue.destinationViewController as? PhotoPickerVC {
          destVC.delegate = self
          if let photo = selectPhoto.imageView?.image {
            destVC.image = photo
          }
        }
      }
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
        if let date = tasks[indexPath.row].dueDate {
          cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
        } else {
          cell.detailTextLabel?.text = "No due date"
        }
        return cell
      }
      return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      performSegueWithIdentifier("showTaskDetail", sender: indexPath)
    }
    
  }
