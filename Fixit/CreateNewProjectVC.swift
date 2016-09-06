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

class CreateNewProjectVC: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var costFld: UITextField!
  @IBOutlet weak var dueDate: UIDatePicker!
  @IBOutlet weak var details: UITextView!
  
  var objectToEdit: NSManagedObject? = nil
  
  override func viewDidLoad() {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
    
    scrollView.delegate = self
    
    let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
    tapGest.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGest)
    
    if objectToEdit != nil {
      populateFields(withObject: objectToEdit!)
    }
    
    details.layer.borderColor = UIColor.blackColor().CGColor
    details.layer.borderWidth = 1.0
    
  }
  
  func populateFields(withObject object: NSManagedObject) {
    if object is Project {
      // TODO: validate data before passing to fields
      let project = object as! Project
      titleFld.text = project.title
      timeFld.text = String(project.estimatedTime)
      costFld.text = String(project.estimatedCost)
      details.text = project.details
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
    
    if let newProject = NSEntityDescription.insertNewObjectForEntityForName("Project", inManagedObjectContext: context) as? Project {
      // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
      newProject.title = titleFld.text!
      newProject.complete = false
      newProject.estimatedCost = Double(costFld.text!)
      newProject.details = details.text
      newProject.dueDate = dueDate.date
      newProject.estimatedTime = Double(timeFld.text!)
      newProject.taskList = nil
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
  
}
