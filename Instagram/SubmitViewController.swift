//
//  SubmitViewController.swift
//  Instagram
//
//  Created by Evan on 2/24/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

protocol SubmitDelegate {
  func didSubmitPhoto(image: UIImage!, caption: String?)
}

class SubmitViewController: UIViewController {

  @IBOutlet weak var previewImageView: UIImageView!
  @IBOutlet weak var captionTextView: UITextField!
  
  @IBOutlet weak var previewImageHeightConstraint: NSLayoutConstraint!
  
  var image: UIImage?
  
  var delegate: SubmitDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let pictureTapRecognizer = UITapGestureRecognizer(target: self, action: "didPressPicture:")
    previewImageView.userInteractionEnabled = true
    previewImageView.addGestureRecognizer(pictureTapRecognizer)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    
    let backgroundTouchRecognizer = UITapGestureRecognizer(target: self, action: "didTapBackground:")
    self.view.addGestureRecognizer(backgroundTouchRecognizer)
    
    resizePicture(0)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func keyboardWillAppear(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
        resizePicture(keyboardSize.height)
      }
    }
  }
  
  func keyboardWillDisappear(notification: NSNotification) {
    resizePicture(0)
  }
  
  func resizePicture(keyboardHeight: CGFloat) {
    
    let bounds = UIScreen.mainScreen().bounds
    let smallestWidth = bounds.height > bounds.width ? bounds.width : bounds.height
    
    if keyboardHeight == 0 {
      previewImageHeightConstraint.constant = smallestWidth - 16
    } else {
      let marginHeights = 38
      let textFieldHeight = 30
      var navigationBarHeight = self.navigationController!.navigationBar.frame.height
      navigationBarHeight += UIApplication.sharedApplication().statusBarFrame.size.height
      previewImageHeightConstraint.constant = bounds.height - CGFloat(marginHeights) - CGFloat(textFieldHeight) - navigationBarHeight - keyboardHeight
    }
    
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
  
  func didTapBackground(view: AnyObject) {
    captionTextView.resignFirstResponder()
  }
  
  @IBAction func didPressClose(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func didPressSubmit(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    if image != nil {
      
      InstagramPost.postUserImage(image, withCaption: captionTextView.text, withCompletion: {
        (success: Bool, error: NSError?) -> Void in
        if success {
          self.delegate?.didSubmitPhoto(self.image, caption: self.captionTextView.text)
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.dismissViewControllerAnimated(true, completion: nil)
        } else {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          //TODO: Display message
        }
      })
      
    } else {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
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