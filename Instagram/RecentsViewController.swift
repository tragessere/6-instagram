//
//  RecentsViewController.swift
//  Instagram
//
//  Created by Evan on 2/23/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

class RecentsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var gradientView: UIView!

  var posts: [InstagramPost]?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.delegate = self
      tableView.dataSource = self
      
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = UIScreen.mainScreen().bounds.width + 30
      
      tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, tabBarController!.tabBar.frame.size.height, 0.0)
      
      let query = PFQuery(className: "Post")
      query.orderByDescending("createdAt")
      query.includeKey("author")
      query.limit = 20
      
      query.findObjectsInBackgroundWithBlock {
        (response: [PFObject]?, error: NSError?) -> Void in
        if response != nil {
//          print("data: \(response!)")
          self.posts = InstagramPost.postsWithArray(response!)
          self.tableView.reloadData()
        } else {
          print("error: \(error!.localizedDescription)")
        }
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      if segue.identifier == "submitSegue" {
        let vc = segue.destinationViewController as! SubmitViewController
        vc.delegate = self
      }
      
    }
  

  @IBAction func didPressAdd(sender: AnyObject) {
  }
}

extension RecentsViewController: UITableViewDelegate, UITableViewDataSource, SubmitDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if posts != nil {
      return posts!.count
    } else {
      return 0
    }
  }
  
//  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return 1
//  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("instagramCell", forIndexPath: indexPath) as! InstagramCell
    
    cell.post = posts![indexPath.row]
    
    return cell;
  }
  
  func didSubmitPhoto(image: UIImage!, caption: String?) {
    //TODO: make this do something
  }
}
