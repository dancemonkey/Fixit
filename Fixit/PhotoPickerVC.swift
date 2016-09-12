//
//  PhotoPickerVC.swift
//  Fixit
//
//  Created by Drew Lanning on 9/11/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class PhotoPickerVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var imagePickerController: UIImagePickerController!
  @IBOutlet weak var photoPreview: UIImageView!
  @IBOutlet weak var cameraButton: UIButton!
  
  var delegate: SaveDelegateData!
  var image: UIImage? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let image = self.image {
      photoPreview.image = image
    }
    
    imagePickerController = UIImagePickerController()
    if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
      cameraButton.enabled = true
    } else {
      cameraButton.enabled = false
      cameraButton.backgroundColor = UIColor.lightGrayColor()
    }
    
  }
  
  @IBAction func donePressed(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: Image Picker Methods
  
  @IBAction func imagePickerPressed(sender: UIButton) {
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    imagePickerController.sourceType = (sender.titleLabel?.text == "Camera" ? .Camera : .PhotoLibrary)
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.photoPreview.contentMode = .ScaleAspectFit
      self.photoPreview.image = pickedImage
      delegate.saveFromDelegate(pickedImage)
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
