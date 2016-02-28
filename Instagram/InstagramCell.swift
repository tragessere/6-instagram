//
//  InstagramCell.swift
//  Instagram
//
//  Created by Evan on 2/23/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse


class InstagramCell: UITableViewCell {
  @IBOutlet weak var instagramImageView: UIImageView!
  @IBOutlet weak var captionLabel: UILabel!
  
  var post: InstagramPost! {
    didSet {
      instagramImageView.image = post.image
      captionLabel.text = post.caption
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
