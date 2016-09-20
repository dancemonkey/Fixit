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
  var startDate: Date? = nil
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var dayOfWeek: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.datePicker.addTarget(self, action: #selector(DueDatePickerVC.datePickerChanged), for: .valueChanged)
    
    if let date = startDate {
      datePicker.setDate(date, animated: true)
    }
    
    dayOfWeek.text = datePicker.date.dayOfTheWeek()
    
  }
  
  func datePickerChanged() {
    dayOfWeek.text = datePicker.date.dayOfTheWeek()
  }
  
  @IBAction func donePressed(_ sender: UIButton) {
    delegate.saveDate(datePicker.date)
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func removeDueDatePressed(_ sender: UIButton) {
    delegate.saveDate(nil)
    _ = self.navigationController?.popViewController(animated: true)
  }
  
}
