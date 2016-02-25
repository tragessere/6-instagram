//
//  SubmitViewController.swift
//  Instagram
//
//  Created by Evan on 2/24/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

protocol SubmitDelegate {
  func didSubmitPhoto(image: UIImage!, caption: String?)
}

class SubmitViewController: UIViewController {

  @IBOutlet weak var previewImageView: UIImageView!
  @IBOutlet weak var captionTextView: UITextField!
  
  var image: UIImage?
  
  var delegate: SubmitDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let pictureTapRecognizer = UITapGestureRecognizer(target: self, action: "didPressPicture:")
    previewImageView.userInteractionEnabled = true
    previewImageView.addGestureRecognizer(pictureTapRecognizer)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  func didPressPicture(view: AnyObject) {
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    
    presentViewController(vc, animated: true, completion: nil)
  }
  
  @IBAction func didPressClose(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func didPressSubmit(sender: AnyObject) {
    if image != nil {
      
      
      delegate?.didSubmitPhoto(image, caption: captionTextView.text)
      dismissViewControllerAnimated(true, completion: nil)
    } else {
      //TODO: Display message
    }
  }
  
  func resize(image: UIImage, newSize: CGSize) -> UIImage {
    let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
    resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
    resizeImageView.image = image
    
    UIGraphicsBeginImageContext(resizeImageView.frame.size)
    resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}

extension SubmitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//    let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
    
    previewImageView.backgroundColor = UIColor.whiteColor()
    previewImageView.image = editedImage
    
    image = resize(editedImage, newSize: CGSize(width: 500, height: 500))
    
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
}