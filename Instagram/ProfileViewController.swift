//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Evan on 2/23/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = 75
    profileImageView.layer.borderColor = UIColor.blackColor().CGColor
    profileImageView.layer.borderWidth = 2
    
    if let imageFile = PFUser.currentUser()!["profile_picture"] as? PFFile {
      do {
        try profileImageView.image = UIImage(data: imageFile.getData())
      } catch {
        //what
      }
    }
    
    usernameLabel.text = PFUser.currentUser()!.username
    
    let pictureTapRecognizer = UITapGestureRecognizer(target: self, action: "didPressPicture:")
    profileImageView.userInteractionEnabled = true
    profileImageView.addGestureRecognizer(pictureTapRecognizer)
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
  
  @IBAction func didPressLogout(sender: AnyObject) {
    PFUser.logOutInBackgroundWithBlock {
      (error: NSError?) -> Void in
      print("logging out")
      
      NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
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


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
    
    
    let image = resize(editedImage, newSize: CGSize(width: 500, height: 500))
    let imageFile = InstagramPost.getPFFileFromImage(image)
    let user = PFUser.currentUser()
    user?.setObject(imageFile!, forKey: "profile_picture")
    user?.saveInBackgroundWithBlock({
      (successful: Bool, error: NSError?) -> Void in
      if successful {
        self.profileImageView.backgroundColor = UIColor.whiteColor()
        self.profileImageView.image = editedImage
        PFUser.currentUser()!.fetchInBackground()
      } else {
        print("Error: \(error!.localizedDescription)")
      }
    })
    
    picker.dismissViewControllerAnimated(true, completion: nil)

  }
  
}