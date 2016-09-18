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
    if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
      cameraButton.isEnabled = true
    } else {
      cameraButton.isEnabled = false
      cameraButton.backgroundColor = UIColor.lightGray
    }
    
  }
  
  @IBAction func donePressed(_ sender: UIButton) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Image Picker Methods
  
  @IBAction func imagePickerPressed(_ sender: UIButton) {
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    imagePickerController.sourceType = (sender.titleLabel?.text == "Camera" ? .camera : .photoLibrary)
    self.present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.photoPreview.contentMode = .scaleAspectFit
      self.photoPreview.image = pickedImage
      delegate.saveFromDelegate(pickedImage)
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}
