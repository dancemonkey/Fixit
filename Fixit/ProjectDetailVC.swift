  //
  //  ProjectDetailVC.swift
  //  Fixit
  //
  //  Created by Drew Lanning on 9/6/16.
  //  Copyright © 2016 Drew Lanning. All rights reserved.
  //
  
  import UIKit
  import CoreData
  
  class ProjectDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveDelegateData, UIScrollViewDelegate, UITextViewDelegate {
    
    var project: Project? = nil
    var taskData: [Task]?
    let dateFormatter = DateFormatter()
    var dueDate: Date!
    let taskHeightConstant: CGFloat = 200
    var photoHeightConstant: CGFloat!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleFld: UITextField!
    @IBOutlet weak var timeFld: UITextField!
    @IBOutlet weak var costFld: UITextField!
    @IBOutlet weak var detailsFld: CustomTextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var selectDueDate: UIButton!
    @IBOutlet weak var taskTableHeight: NSLayoutConstraint!
    @IBOutlet weak var newTaskBtn: UIButton!
    @IBOutlet weak var photoBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      let notificationCenter = NotificationCenter.default
      notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
      
      scrollView.delegate = self
      detailsFld.delegate = self
      photoHeightConstant = selectPhoto.frame.width
      
      let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
      tapGest.cancelsTouchesInView = false
      scrollView.addGestureRecognizer(tapGest)
      
      detailsFld.layer.borderColor = UIColor.black.cgColor
      detailsFld.layer.borderWidth = 1.0
      
      tableView.delegate = self
      tableView.dataSource = self
      
      dateFormatter.dateFormat = "M/d/yy"
      
      if project == nil {
        self.navigationItem.title = "New project"
        selectPhoto.setTitle("Tap to add photo", for: UIControlState())
        selectDueDate.setTitle("Set due date...", for: UIControlState())
        self.newTaskBtn.isEnabled = false
        self.newTaskBtn.backgroundColor = UIColor.gray
        self.newTaskBtn.setTitleColor(UIColor.lightGray, for: UIControlState())
        trashBtn.isEnabled = false
      }
      
      if let project = self.project {
        
        self.newTaskBtn.isEnabled = true
        trashBtn.isEnabled = true
        
        self.navigationItem.title = project.title
        
        if let title = project.title {
          titleFld.text = title
        }
        if let time = project.estimatedTime {
          timeFld.text = String(describing: time)
        }
        if let cost = project.estimatedCost {
          costFld.text = String(describing: cost)
        }
        if let dueDate = project.dueDate {
          selectDueDate.setTitle("Due " + dateFormatter.string(from: dueDate as Date), for: UIControlState())
          self.dueDate = dueDate as Date!
        }
        if let photo = project.photo?.data {
          selectPhoto.setImage(UIImage(data: photo as Data), for: UIControlState())
          adjustPhotoHeight()
        }
        if let tasks = project.taskList , tasks.count > 0 {
          taskTableHeight.constant = 200
          refreshTableData(withTasks: tasks)
        }
        if let details = project.details , details != "" {
          detailsFld.text = details
        }
      }
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let project = self.project {
        if let tasks = project.taskList , tasks.count > 0 {
          taskTableHeight.constant = taskHeightConstant
          refreshTableData(withTasks: tasks)
        }
      }
      if selectPhoto.imageView?.image != nil {
        adjustPhotoHeight()
      }
      self.tableView.reloadData()
    }
    
    @IBAction func deleteCompletedPressed(_ sender: UIBarButtonItem) {
      
      let alert = UIAlertController(title: "Confirm", message: "You are about to delete this project!", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { (action: UIAlertAction) in
        
        appDelegate.managedObjectContext.delete(self.project!)
        _ = self.navigationController?.popViewController(animated: true)
        
      }))
      
      self.present(alert, animated: true, completion: nil)
      
    }
    
    func refreshTableData(withTasks tasks: NSSet) {
      let primarySortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
      self.taskData = (tasks.sortedArray(using: [primarySortDesc]) as? [Task])?.filter{ (task: Task) -> Bool in
        return task.completed == false
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
      }
      scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func saveFromDelegate(_ data: AnyObject) {
      if data is Date {
        self.dueDate = data as! Date
        selectDueDate.setTitle("Due " + dateFormatter.string(from: dueDate), for: UIControlState())
      } else if data is UIImage {
        selectPhoto.setImage(data as? UIImage, for: UIControlState())
        selectPhoto.imageView?.contentMode = .scaleAspectFit
      }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
      let context = appDelegate.managedObjectContext
      
      let formatter = NumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .currency
      formatter.locale = .current
      
      if project == nil {
        if let newProject = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as? Project {
          
          // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
          newProject.title = titleFld.text!
          newProject.complete = false
          newProject.estimatedCost = Double(costFld.text!) as NSNumber?
          newProject.details = detailsFld.text
          newProject.dueDate = self.dueDate
          newProject.estimatedTime = Double(timeFld.text!) as NSNumber?
          if let photo = selectPhoto.imageView?.image, let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
            newPhoto.data = UIImagePNGRepresentation(photo)
            newProject.photo = newPhoto
          }
        }
      } else {
        
        // TODO: VALIDATE ENTRIES BEFORE TRYING TO SAVE THEM TO ENTITY
        project!.title = titleFld.text!
        project!.complete = false
        project!.estimatedCost = Double(costFld.text!) as NSNumber?
        project!.details = detailsFld.text
        project!.dueDate = self.dueDate
        project!.estimatedTime = Double(timeFld.text!) as NSNumber?
        if let photo = selectPhoto.imageView?.image, let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
          newPhoto.data = UIImagePNGRepresentation(photo)
          project!.photo = newPhoto
        }
        if let tasks = project!.taskList {
          for task in tasks {
            (task as AnyObject).setValue(project!, forKey: "parentProject")
            (task as AnyObject).setValue(project!.title, forKey: "sectionName")
          }
        }
      }
      
      do {
        try context.save()
        _ = self.navigationController?.popViewController(animated: true)
      } catch {
        print(error)
      }
      
    }
    
    func adjustPhotoHeight() {
      selectPhoto.imageView?.contentMode = .scaleAspectFit
      photoBtnHeight.constant = photoHeightConstant
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDueDatePicker" {
        if let destVC = segue.destination as? DueDatePickerVC {
          destVC.delegate = self
          destVC.startDate = self.dueDate
        }
      } else if segue.identifier == "createNewTask" {
        if let destVC = segue.destination as? TaskDetailVC {
          destVC.project = self.project
        }
      } else if segue.identifier == "showTaskDetail" {
        if let destVC = segue.destination as? TaskDetailVC {
          destVC.task = self.taskData![((sender as! IndexPath) as NSIndexPath).row]
        }
      } else if segue.identifier == "showPhotoDetail" {
        if let destVC = segue.destination as? PhotoPickerVC {
          destVC.delegate = self
          if let photo = selectPhoto.imageView?.image {
            destVC.image = photo
          }
        }
      }
    }
    
    // MARK: Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if let tasks = taskData {
        return tasks.count
      }
      return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let tasks = taskData, let cell = tableView.dequeueReusableCell(withIdentifier: "miniTaskCell") {
        cell.textLabel?.text = tasks[(indexPath as NSIndexPath).row].title
        if let date = tasks[(indexPath as NSIndexPath).row].dueDate {
          cell.detailTextLabel?.text = dateFormatter.string(from: date as Date)
        } else {
          cell.detailTextLabel?.text = "No due date"
        }
        return cell
      }
      return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      performSegue(withIdentifier: "showTaskDetail", sender: indexPath)
    }
    
    // MARK: TextView delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      if detailsFld.textColor == detailsFld.placeholderColor {
        detailsFld.text = nil
        detailsFld.textColor = detailsFld.defaultColor
      }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
      if detailsFld.text.isEmpty {
        detailsFld.text = detailsFld.placeholderText
        detailsFld.textColor = detailsFld.placeholderColor
      }
    }
    
  }
