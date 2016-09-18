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
  @IBOutlet weak var photoBtnHeight: NSLayoutConstraint!
  
  var task: Task? = nil
  var project: Project? = nil
  let dateFormatter = DateFormatter()
  var dueDate: Date!
  let blankSectionName = "No associated project"
  var photoBtnHeightConst: CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setCompleteBtnStatus()
    
    details.layer.borderColor = UIColor.black.cgColor
    details.layer.borderWidth = 1.0
    details.delegate = self
    
    photoBtnHeightConst = photoSelectBtn.frame.width
    
    dateFormatter.dateFormat = "M/d/yy"
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    scrollView.delegate = self
    
    let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
    tapGest.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGest)
    
    if task == nil {
      self.navigationItem.title = "New task"
      photoSelectBtn.setTitle("Tap to add photo", for: UIControlState())
      dueDateSelectBtn.setTitle("Due date...", for: UIControlState())
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
      if let dueDate = task.dueDate {
        dueDateSelectBtn.setTitle("Due " + dateFormatter.string(from: dueDate as Date), for: UIControlState())
        self.dueDate = dueDate as Date!
      }
      if let photo = task.photo?.data {
        photoSelectBtn.setImage(UIImage(data: photo as Data), for: UIControlState())
        photoSelectBtn.imageView?.contentMode = .scaleAspectFit
        photoBtnHeight.constant = photoBtnHeightConst
      }
      if let details = task.details , details != "" {
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func adjustForKeyboard(_ notification: Notification) {
    let userInfo = (notification as NSNotification).userInfo!
    
    let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == NSNotification.Name.UIKeyboardWillHide {
      scrollView.contentInset = UIEdgeInsets.zero
    } else {
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
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
      completeBtn.title = "Tap to complete"
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
      } else {
        task.completed = false
        setCompleteBtnStatus()
      }
    }
  }
  
  @IBAction func savePressed(_ sender: UIBarButtonItem) {
    
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
        newTask.dueDate = self.dueDate
        newTask.time = Int(timeFld.text!) as NSNumber?
        if let photo = photoSelectBtn.imageView?.image, let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
          newPhoto.data = UIImagePNGRepresentation(photo)
          newTask.photo = newPhoto
        }
        if let project = self.project {
          newTask.parentProject = project
          if let title = project.title {
            newTask.sectionName = title
          } else {
            newTask.sectionName = blankSectionName
          }
        }
        newTask.shoppingList = shoppingListSwitch.isOn as NSNumber?
      }
    } else {
      
      // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
      task!.title = titleFld.text!
      //task!.completed = false
      task!.cost = Double(costFld.text!) as NSNumber?
      task!.details = details.text
      task!.dueDate = self.dueDate
      task!.time = Int(timeFld.text!) as NSNumber?
      if let photo = photoSelectBtn.imageView?.image, let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
        newPhoto.data = UIImagePNGRepresentation(photo)
        task!.photo = newPhoto
      }
      if let project = self.project {
        task!.parentProject = project
        if let title = project.title {
          task!.sectionName = title
        } else {
          task!.sectionName = blankSectionName
        }
      }
      task!.shoppingList = shoppingListSwitch.isOn as NSNumber?
    }
    
    save(withPop: true)
    
  }
  
  @IBAction func cancelPressed(_ sender: UIButton) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func selectProjectPressed(_ sender: UIButton) {
    performSegue(withIdentifier: "selectAProject", sender: self)
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
        if let photo = photoSelectBtn.imageView?.image {
          destVC.image = photo
        }
      }
    }
  }
  
  func saveFromDelegate(_ data: AnyObject) {
    if data is Project {
      setProject(withProject: (data as? Project)!)
    } else if data is Date {
      self.dueDate = data as? Date
      dueDateSelectBtn.setTitle("Due " + dateFormatter.string(from: self.dueDate), for: UIControlState())
    } else if data is UIImage {
      photoSelectBtn.setImage(data as? UIImage, for: UIControlState())
      photoSelectBtn.imageView?.contentMode = .scaleAspectFit
      photoBtnHeight.constant = photoBtnHeightConst
    }
  }
  
  func setProject(withProject project: Project) {
    self.project = project
    self.projectSelectBtn.setTitle(self.project?.title, for: UIControlState())
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
    }
  }

}
