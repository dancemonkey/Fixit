//
//  TaskDetailVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/6/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailVC: UIViewController, UIScrollViewDelegate, SaveDelegateData, UITextViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var costFld: UITextField!
  @IBOutlet weak var dueDateSelectBtn: UIButton!
  @IBOutlet weak var details: CustomTextView!
  @IBOutlet weak var projectSelectBtn: UIButton!
  @IBOutlet weak var photoSelectBtn: UIButton!
  @IBOutlet weak var shoppingListSwitch: UISwitch!
  @IBOutlet weak var completeBtn: UIBarButtonItem!
  
  var task: Task? = nil
  var project: Project? = nil
  let dateFormatter = DateFormatter()
  var dueDate: Date!
  let blankSectionName = "No project"
  var photoBtnHeightConst: CGFloat!
  var currentPhoto: UIImage? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setCompleteBtnStatus()

    details.delegate = self
    
    dateFormatter.dateFormat = "M/d/yy"
    
    photoSelectBtn.imageView?.contentMode = .scaleAspectFill
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    scrollView.delegate = self
    
    let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
    tapGest.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGest)
    
    if task == nil {
      self.navigationItem.title = "New task"
      photoSelectBtn.setTitle("+ Add photo", for: UIControlState())
      dueDateSelectBtn.setTitle("Due date...", for: UIControlState())
      titleFld.becomeFirstResponder()
    }
    
    if let task = self.task {
      
      if let title = task.title {
        self.navigationItem.title = task.title
        titleFld.text = title
      }
      if let time = task.time {
        timeFld.text = String(describing: time)
      }
      if let cost = task.cost {
        costFld.text = String(describing: cost)
      }
      if let dueDate = task.dueDate, dueDate != Date.distantFuture {
        dueDateSelectBtn.setTitle("Due " + dateFormatter.string(from: dueDate as Date), for: UIControlState())
        self.dueDate = dueDate as Date!
      }
      if let photo = task.photo?.data {
        photoSelectBtn.setImage(UIImage(data: photo as Data), for: UIControlState())
        photoSelectBtn.imageView?.contentMode = .scaleAspectFill
        currentPhoto = UIImage(data: photo as Data)
      }
      if let details = task.details , details != "" , details != "Notes" {
        self.details.text = details
        self.details.textColor = self.details.defaultColor
      }
      if let project = task.parentProject {
        self.saveProject(project)
      }
      
      shoppingListSwitch.setOn((task.shoppingList?.boolValue)!, animated: true)
      
    }
    
    if let project = self.project {
      self.saveProject(project)
    }
    
  }
  
  func hideKeyboard() {
    self.view.endEditing(true)
  }
  
  func adjustForKeyboard(_ notification: Notification) {
    let userInfo = (notification as NSNotification).userInfo!
    
    let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == NSNotification.Name.UIKeyboardWillHide {
      scrollView.contentInset = UIEdgeInsets.zero
    } else {
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
      
      // figure out if details is off screen and scroll to it
      let screenSize: CGRect = UIScreen.main.bounds
      let screenHeight = screenSize.height
      let height:CGFloat=screenHeight-(keyboardScreenEndFrame.size.height)-(details!.frame.size.height)
      if details.frame.origin.y >= height {
        let scrollPoint = CGPoint(x: 0.0, y: details.frame.origin.y-25) // 25 is just a buffer so it's not flush with the top
        self.scrollView.setContentOffset(scrollPoint, animated: true)
      }
      
    }
    scrollView.scrollIndicatorInsets = scrollView.contentInset
  }
  
  func setCompleteBtnStatus() {
    if let task = self.task {
      completeBtn.isEnabled = !(task.completed?.boolValue)!
      if completeBtn.isEnabled == false {
        completeBtn.title = "Task Completed"
      }
    } else {
      completeBtn.isEnabled = false
      completeBtn.title = "Complete task"
    }
  }
  
  func save(withPop pop: Bool) {
    let context = appDelegate.managedObjectContext
    do {
      try context.save()
      if pop {
        _ = self.navigationController?.popViewController(animated: true)
      }
    } catch {
      print(error)
    }
  }
  
  @IBAction func completePressed(_ sender: UIBarButtonItem) {
    if let task = self.task {
      if task.completed == false {
        task.completed = true
        setCompleteBtnStatus()
        updateBadge()
      } else {
        task.completed = false
        setCompleteBtnStatus()
        updateBadge()
      }
    }
  }
  
  @IBAction func savePressed(_ sender: UIBarButtonItem) {
    
    defer {
      updateBadge()
    }
    
    let context = appDelegate.managedObjectContext
    
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = .current
    
    if self.task == nil {
      if let newTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as? Task {
        
        // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
        newTask.title = titleFld.text!
        newTask.completed = false
        newTask.cost = Double(costFld.text!) as NSNumber?
        newTask.details = details.text
        
        // hack to allow NIL due dates to sort at bottom of list view
        if let date = self.dueDate {
          newTask.dueDate = date
        } else {
          newTask.dueDate = Date.distantFuture
        }
        
        newTask.time = Int(timeFld.text!) as NSNumber?
        if let photo = currentPhoto, let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
          newPhoto.data = UIImagePNGRepresentation(photo)
          newTask.photo = newPhoto
        }
        
        newTask.parentProject = self.project
        if let project = self.project {
          if let title = project.title {
            newTask.parentProjectTitle = title
          } else {
            newTask.parentProjectTitle = blankSectionName
          }
        }
        newTask.shoppingList = shoppingListSwitch.isOn as NSNumber?
      }
    } else {
      
      // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
      task!.title = titleFld.text!
      task!.cost = Double(costFld.text!) as NSNumber?
      task!.details = details.text
      
      // hack to allow NIL due dates to sort at bottom of list view
      if let date = self.dueDate {
        task!.dueDate = date
      } else {
        task!.dueDate = Date.distantFuture
      }
      
      task!.time = Int(timeFld.text!) as NSNumber?
      if let photo = currentPhoto, let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
        newPhoto.data = UIImagePNGRepresentation(photo)
        task!.photo = newPhoto
      }
      
      task!.parentProject = self.project
      if let project = self.project {
        if let title = project.title {
          task!.parentProjectTitle = title
        }
      } else {
        task!.parentProjectTitle = blankSectionName
      }
      task!.shoppingList = shoppingListSwitch.isOn as NSNumber?
    }
    
    save(withPop: true)
    
  }
  
  @IBAction func cancelPressed(_ sender: UIButton) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func selectProjectPressed(_ sender: UIButton) {
    Utils.animateButton(sender, withTiming: btnAnimTiming) {
      self.performSegue(withIdentifier: "selectAProject", sender: self)
    }
  }
  
  @IBAction func addPhotoPressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: btnAnimTiming) {
      self.performSegue(withIdentifier: "showPhotoDetail", sender: sender)
    }
  }
  
  @IBAction func selectDueDatePressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: btnAnimTiming) {
      self.performSegue(withIdentifier: "showDueDatePicker", sender: sender)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "selectAProject" {
      if let destVC = segue.destination as? ProjectSelectVC {
        destVC.delegate = self
      }
    } else if segue.identifier == "showDueDatePicker" {
      if let destVC = segue.destination as? DueDatePickerVC {
        destVC.delegate = self
        destVC.startDate = self.dueDate
      }
    } else if segue.identifier == "showPhotoDetail" {
      if let destVC = segue.destination as? PhotoPickerVC {
        destVC.delegate = self
        if let photo = currentPhoto {
          destVC.image = photo
        }
      }
    }
  }
  
  // MARK: Protocol methods
  
  func saveProject(_ project: Project?) {
    self.project = project
    if let proj = project {
      self.projectSelectBtn.setTitle(proj.title, for: UIControlState())
    } else {
      self.projectSelectBtn.setTitle("Select project", for: .normal)
    }
  }
  
  func saveImage(_ image: UIImage?) {
    if let img = image {
      photoSelectBtn.setImage(img, for: .normal)
      photoSelectBtn.imageView?.contentMode = .scaleAspectFill
      currentPhoto = img
    } else {
      photoSelectBtn.setImage(nil, for: .normal)
      currentPhoto = nil
      if let photo = self.task?.photo {
        self.task?.photo = nil
        appDelegate.managedObjectContext.delete(photo)
      }
    }
  }
  
  func saveDate(_ date: Date?) {
    if let pickedDate = date {
      self.dueDate = Calendar.current.startOfDay(for: pickedDate)
      dueDateSelectBtn.setTitle("Due " + dateFormatter.string(from: self.dueDate), for: UIControlState())
    } else {
      self.dueDate = nil
      dueDateSelectBtn.setTitle("Set due date...", for: UIControlState())
    }
  }
  
  // MARK: TextView delegate methods
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if details.textColor == details.placeholderColor {
      details.text = nil
      details.textColor = details.defaultColor
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if details.text.isEmpty {
      details.text = details.placeholderText
      details.textColor = details.placeholderColor
    } else {
      details.textColor = details.defaultColor
    }
  }
  
}
