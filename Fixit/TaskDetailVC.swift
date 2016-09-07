//
//  TaskDetailVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/6/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailVC: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, SaveDelegateData, UIImagePickerControllerDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var costFld: UITextField!
  @IBOutlet weak var dueDateSelectBtn: UIButton!
  @IBOutlet weak var details: UITextView!
  @IBOutlet weak var projectSelectBtn: UIButton!
  @IBOutlet weak var photoSelectBtn: UIButton!
  @IBOutlet weak var photoSelectBtnHeight: NSLayoutConstraint!
  @IBOutlet weak var shoppingListSwitch: UISwitch!
  
  var task: Task? = nil
  var project: Project? = nil
  let dateFormatter = NSDateFormatter()
  var imagePickerController: UIImagePickerController!
  var dueDate: NSDate!
  let imagePickerButtonHeight: CGFloat = 200
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    details.layer.borderColor = UIColor.blackColor().CGColor
    details.layer.borderWidth = 1.0
    
    dateFormatter.dateFormat = "M/d/yy"
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
    
    scrollView.delegate = self
    
    let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
    tapGest.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGest)
    
    if task == nil {
      self.navigationItem.title = "New task"
      photoSelectBtn.setTitle("Tap to select", forState: .Normal)
      dueDateSelectBtn.setTitle("Due date...", forState: .Normal)
    }
    
    if let task = self.task {
      if let title = task.title {
        self.navigationItem.title = task.title
        titleFld.text = title
      }
      if let time = task.time {
        timeFld.text = String(time)
      }
      if let cost = task.cost {
        costFld.text = String(cost)
      }
      if let dueDate = task.dueDate {
        dueDateSelectBtn.setTitle("Due " + dateFormatter.stringFromDate(dueDate), forState: .Normal)
        self.dueDate = dueDate
      }
      if let photo = task.photo?.data {
        photoSelectBtnHeight.constant = imagePickerButtonHeight
        photoSelectBtn.setImage(UIImage(data: photo), forState: .Normal)
      }
      if let details = task.details {
        self.details.text = details
      }
      if let project = task.parentProject {
        self.setProject(withProject: project)
      }
      
      shoppingListSwitch.setOn((task.shoppingList?.boolValue)!, animated: true)

    }
    
    if let project = self.project {
      self.setProject(withProject: project)
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
    
    if self.task == nil {
      if let newTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: context) as? Task {
        
        // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
        newTask.title = titleFld.text!
        newTask.completed = false
        newTask.cost = Double(costFld.text!)
        newTask.details = details.text
        newTask.dueDate = self.dueDate
        newTask.time = Int(timeFld.text!)
        if let photo = photoSelectBtn.imageView?.image, let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as? Photo {
          newPhoto.data = UIImagePNGRepresentation(photo)
          newTask.photo = newPhoto
        }
        if let project = self.project {
          newTask.parentProject = project
        }
        newTask.shoppingList = shoppingListSwitch.on
      }
    } else {
      
      // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
      task!.title = titleFld.text!
      task!.completed = false
      task!.cost = Double(costFld.text!)
      task!.details = details.text
      task!.dueDate = self.dueDate
      task!.time = Int(timeFld.text!)
      if let photo = photoSelectBtn.imageView?.image, let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as? Photo {
        newPhoto.data = UIImagePNGRepresentation(photo)
        task!.photo = newPhoto
      }
      if let project = self.project {
        task!.parentProject = project
      }
      task!.shoppingList = shoppingListSwitch.on
    }
    
    do {
      try context.save()
      self.navigationController?.popViewControllerAnimated(true)
    } catch {
      print(error)
    }
    
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func selectProjectPressed(sender: UIButton) {
    performSegueWithIdentifier("selectAProject", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "selectAProject" {
      if let destVC = segue.destinationViewController as? ProjectSelectVC {
        destVC.delegate = self
      }
    } else if segue.identifier == "showDueDatePicker" {
      if let destVC = segue.destinationViewController as? DueDatePickerVC {
        destVC.delegate = self
        destVC.startDate = self.dueDate
      }
    }
  }
  
  func saveFromDelegate(data: AnyObject) {
    if data is Project {
      setProject(withProject: (data as? Project)!)
    } else if data is NSDate {
      self.dueDate = data as? NSDate
      dueDateSelectBtn.setTitle("Due " + dateFormatter.stringFromDate(self.dueDate), forState: .Normal)
    }
  }
  
  func setProject(withProject project: Project) {
    self.project = project
    self.projectSelectBtn.setTitle(self.project?.title, forState: .Normal)
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
      self.photoSelectBtn.contentMode = .ScaleAspectFill
      self.photoSelectBtn.setImage(pickedImage, forState: .Normal)
      self.photoSelectBtn.setTitle("", forState: .Normal)
      self.photoSelectBtnHeight.constant = imagePickerButtonHeight
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  
}
