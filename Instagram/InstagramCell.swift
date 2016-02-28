//
//  InstagramCell.swift
//  Instagram
//
//  Created by Evan on 2/23/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

protocol InstagramCellDelegate {
  func didTapImage(imageView: UIImageView)
}

class InstagramCell: UITableViewCell {
  @IBOutlet weak var instagramImageView: UIImageView!
  @IBOutlet weak var captionLabel: UILabel!
  
  var delegate: InstagramCellDelegate?
  
  var post: InstagramPost! {
    didSet {
      instagramImageView.image = post.image
      captionLabel.text = post.caption
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    let imageTapRecognizer = UITapGestureRecognizer(target: self, action: "didTapImage:")
    instagramImageView.userInteractionEnabled = true
    instagramImageView.addGestureRecognizer(imageTapRecognizer)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  func didTapImage(view: AnyObject) {
    if post.image != nil {
      delegate?.didTapImage(instagramImageView)
    }
  }

}
