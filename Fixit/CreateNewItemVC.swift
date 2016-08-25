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
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    scrollView.delegate = self
    
  }
  
  @IBAction func doneBtnPressed(sender: UIButton) {
    // test for valid entries and save new project or task to context
    // for now just testing saving to context so I can get some data into the system
    
    do {
      
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
    } else {
      projectBtnLabel.enabled = false
      projectSelectBtn.enabled = false
    }
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}
