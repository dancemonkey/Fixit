//
//  CreateNewTaskVC.swift
//  Fixit
//
//  Created by Drew Lanning on 8/31/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class CreateNewTaskVC: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var costFld: UITextField!
  @IBOutlet weak var dueDate: UIDatePicker!
  @IBOutlet weak var details: UITextView!
  
  var objectToEdit: NSManagedObject? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
  }
  
  func populateFields(withObject object: NSManagedObject) {
    if object is Task {
      // TODO: validate data before passing to fields
      let task = object as! Task
      titleFld.text = task.title
      timeFld.text = String(task.time)
      costFld.text = String(task.cost)
      details.text = task.details
      dueDate.setDate(task.dueDate!, animated: true)
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
    
    if let newTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: context) as? Task {
      // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
      newTask.title = titleFld.text!
      newTask.completed = false
      newTask.cost = Double(costFld.text!)
      newTask.details = details.text
      newTask.dueDate = dueDate.date
      newTask.time = Int(timeFld.text!)
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
    
  }
  
}
