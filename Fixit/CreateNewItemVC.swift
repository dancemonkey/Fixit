//
//  CreateNewItemVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/24/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import pop

enum ProjectOrTask: String {
  case Project
  case Task
}

class CreateNewItemVC: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var projectTaskSwitch: UISwitch!
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var costFld: UITextField!
  @IBOutlet weak var dueDate: UIDatePicker!
  @IBOutlet weak var projectBtnLabel: UILabel!
  @IBOutlet weak var details: UITextView!
  @IBOutlet weak var projectSelectBtn: UIButton!
  @IBOutlet weak var selectPhotoBtn: UIButton!
  
  var projectOrTask: ProjectOrTask = .Project
  var objectToEdit: NSManagedObject? = nil
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
    
    scrollView.delegate = self
    
    let tapGest = UITapGestureRecognizer(target: self, action: #selector(CreateNewItemVC.hideKeyboard))
    tapGest.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGest)
    
    if objectToEdit != nil {
      populateFields(withObject: objectToEdit!)
    }
    
  }
  
  func populateFields(withObject object: NSManagedObject) {
    if object is Task {
      // TODO: validate data before passing to fields
      let task = object as! Task
      projectTaskSwitch.setOn(true, animated: true)
      titleFld.text = task.title
      timeFld.text = String(task.time)
      costFld.text = String(task.cost)
      details.text = task.details
      if let image = task.photo { // TODO: rewrite Task as a to-one with Image
        //selectPhotoBtn.setBackgroundImage(UIImage(data: image), forState: .Normal)
      }
      dueDate.setDate(task.dueDate!, animated: true)
    } else if object is Project {
      // TODO: validate data before passing to fields
      let project = object as! Project
      projectTaskSwitch.setOn(false, animated: true)
      titleFld.text = project.title
      timeFld.text = String(project.estimatedTime)
      costFld.text = String(project.estimatedCost)
      details.text = project.details
      if let image = project.photo { // TODO: rewrite Task as a to-one with Image
        //selectPhotoBtn.setBackgroundImage(UIImage(data: image), forState: .Normal)
      }
      dueDate.setDate(project.dueDate!, animated: true)
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
  
  @IBAction func doneBtnPressed(sender: UIButton) {
    
    let context = appDelegate.managedObjectContext
    
    if projectOrTask == .Task {
      if let newTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: context) as? Task {
        // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
        newTask.title = titleFld.text!
        newTask.completed = false
        newTask.cost = Double(costFld.text!)
        newTask.details = details.text
        newTask.dueDate = dueDate.date
        newTask.time = Int(timeFld.text!)
        newTask.parentProject = nil
        newTask.photo = nil
      }
    } else {
      if let newProject = NSEntityDescription.insertNewObjectForEntityForName("Project", inManagedObjectContext: context) as? Project {
        // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
        newProject.title = titleFld.text!
        newProject.complete = false
        newProject.estimatedCost = Double(costFld.text!)
        newProject.details = details.text
        newProject.dueDate = dueDate.date
        newProject.estimatedTime = Int(timeFld.text!)
        if let photo = selectPhotoBtn.currentBackgroundImage {
          let newPic = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as? Photo
          newPic?.data = UIImagePNGRepresentation(photo)
          newProject.photo = newPic
        }
        newProject.taskList = nil
      }
    }
    
    do {
      try context.save()
      self.navigationController?.popViewControllerAnimated(true)
    } catch {
      print(error)
    }
  }
  
  @IBAction func selectProjectBtnPressed(sender: UIButton) {
    
  }
  
  @IBAction func switchChanged(sender: UISwitch) {
    if sender.on {
      projectBtnLabel.enabled = true
      projectSelectBtn.enabled = true
      self.projectOrTask = .Task
    } else {
      projectBtnLabel.enabled = false
      projectSelectBtn.enabled = false
      self.projectOrTask = .Project
    }
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func selectPicture(sender: UIButton) {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    presentViewController(picker, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    var newImage: UIImage
    
    if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      newImage = possibleImage
    } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      newImage = possibleImage
    } else {
      return
    }
    
    selectPhotoBtn.setBackgroundImage(newImage, forState: .Normal)
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
