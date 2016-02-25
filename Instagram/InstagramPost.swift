//
//  InstagramPost.swift
//  Instagram
//
//  Created by Evan on 2/24/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

class InstagramPost: NSObject {

  var user: PFUser?
  var image: UIImage?
  var caption: String?
  
  init(postObject: PFObject) {
    user = postObject["author"] as? PFUser
    let imageFile = postObject["picture"] as? PFFile
    
    if imageFile != nil {
      do {
        try image = UIImage(data: imageFile!.getData())
      } catch {
        //do nothing
      }
    }
    
    caption = postObject["caption"] as? String
  }
  
  class func postsWithArray(array: [PFObject]) -> [InstagramPost] {
    var posts = [InstagramPost]()
    
    for post in array {
      posts.append(InstagramPost(postObject: post))
    }
    
    return posts
  }
  
  class func postUserImage(image: UIImage?, withCaption caption: String? , withCompletion completion: PFBooleanResultBlock?) {
    let post = PFObject(className: "Post")
    
    if image == nil {
      return
    }
    
//    let imageData = UIImageJPEGRepresentation(image!, 1.0)
//    let imageFile = PFFile(data: imageData!)
//    imageFile!.save()
    
    post["picture"] = getPFFileFromImage(image!)
    post["author"] = PFUser.currentUser()
    post["caption"] = caption
    post["likes_count"] = 0
    post["comments_count"] = 0
    
    post.saveInBackgroundWithBlock(completion)
  }
  
  class func getPFFileFromImage(image:UIImage?) -> PFFile? {
    if let image = image {
      if let imageData = UIImagePNGRepresentation(image) {
        return PFFile(name: "image.png", data: imageData)
      }
    }
    return nil
  }
  
}
