//
//  InstagramCellHeader.swift
//  Instagram
//
//  Created by /Users/evan/Documents/CS490/6-instagram/Instagram/SubmitViewController.swiftEvan on 2/27/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

protocol InstagramCellHeaderDelegate {
  func didPressProfile(user: PFUser?)
}

class InstagramCellHeader: UIView {
  
  let profileView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
  let usernameLabel = UILabel(frame: CGRect(x: 50, y: 6, width: 125, height: 30))
  let timeStampLabel = UILabel(frame: CGRect(x: 175, y: 6, width: 140, height: 30))
  
  var delegate: InstagramCellHeaderDelegate?
  
  var post: InstagramPost! {
    didSet {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MMM d, hh:mm a"
      timeStampLabel.text = formatter.stringFromDate(post.createdAt!)
      
      let user = post.user
      
      if user != nil {
        usernameLabel.text = user!.username
        
        if let imageFile = user!["profile_picture"] as? PFFile {
          do {
            try profileView.image = UIImage(data: imageFile.getData())
          } catch {
            //what
          }
        }
      }
    }
  }
  
  // MARK: Inititialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor(white: 1, alpha: 0.9)
    
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 15
    profileView.layer.borderColor = UIColor.blackColor().CGColor
    profileView.layer.borderWidth = 1
    
    usernameLabel.font = usernameLabel.font.fontWithSize(15)
    
    timeStampLabel.font = timeStampLabel.font.fontWithSize(13)
    timeStampLabel.textColor = UIColor.lightGrayColor()
    
    
    addSubview(profileView)
    addSubview(usernameLabel)
    addSubview(timeStampLabel)
    
    let profileTapRecognizer = UITapGestureRecognizer(target: self, action: "profileTapped:")
    profileView.userInteractionEnabled = true
    profileView.addGestureRecognizer(profileTapRecognizer)
    
    let profilePictureTapRecognizer = UITapGestureRecognizer(target: self, action: "profileTapped:")
    usernameLabel.userInteractionEnabled = true
    usernameLabel.addGestureRecognizer(profilePictureTapRecognizer)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  func profileTapped(view: AnyObject) {
    if delegate != nil {
      delegate?.didPressProfile(post.user)
    }
  }

}
