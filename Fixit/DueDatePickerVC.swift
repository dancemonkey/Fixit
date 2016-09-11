//
//  DueDatePickerVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/6/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class DueDatePickerVC: UIViewController {
  
  var delegate: SaveDelegateData!
  var startDate: NSDate? = nil
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var dayOfWeek: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.datePicker.addTarget(self, action: #selector(DueDatePickerVC.datePickerChanged), forControlEvents: .ValueChanged)
    
    if let date = startDate {
      datePicker.setDate(date, animated: true)
    }
    
    dayOfWeek.text = datePicker.date.dayOfTheWeek()
    
  }
  
  func datePickerChanged() {
    dayOfWeek.text = datePicker.date.dayOfTheWeek()
  }
  
  @IBAction func donePressed(sender: UIButton) {
    delegate.saveFromDelegate(datePicker.date)
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}
