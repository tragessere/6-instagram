//
//  ProfileCell.swift
//  Instagram
//
//  Created by Evan on 2/27/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

class ProfileCell: UITableViewCell {
  @IBOutlet weak var blurProfileImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
  
  var user: PFUser! {
    didSet {
        usernameLabel.text = user.username
        if let imageFile = user["profile_picture"] as? PFFile {
        do {
          try profileImageView.image = UIImage(data: imageFile.getData())
          try blurProfileImageView.image = UIImage(data: imageFile.getData())
        } catch {
          profileImageView.backgroundColor = UIColor.whiteColor()
        }
      } else {
        profileImageView.backgroundColor = UIColor.whiteColor()
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = 75
    profileImageView.layer.borderColor = UIColor.blackColor().CGColor
    profileImageView.layer.borderWidth = 2
    
    blurProfileImageView.clipsToBounds = true    
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
