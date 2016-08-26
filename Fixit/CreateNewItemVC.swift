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

class CreateNewItemVC: UIViewController, UIScrollViewDelegate {
  
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
  
  var newCreation: NSManagedObject? = nil
  var projectOrTask: ProjectOrTask = .Project
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
    
    scrollView.delegate = self
    
    let tapGest = UITapGestureRecognizer(target: self, action: #selector(CreateNewItemVC.hideKeyboard))
    tapGest.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGest)
    
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
    // test for valid entries and save new project or task to context
    // figure out if it's a project or task
    // create new entity description
    // set the values
    // insert new ns managed object into context
    
    do {
      try appDelegate.managedObjectContext.save()
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
  
}
