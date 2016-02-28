//
//  ProfilePreviewViewController.swift
//  Instagram
//
//  Created by Evan on 2/27/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

class ProfilePreviewViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var user: PFUser?
  var posts: [InstagramPost]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    tableView.delegate = self
    tableView.dataSource = self
    
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = UIScreen.mainScreen().bounds.width + 30
    
//    tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, tabBarController!.tabBar.frame.size.height, 0.0)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    
    refresh(refreshControl)
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
  
  func refresh(refreshControl: UIRefreshControl) {
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
      refreshControl.endRefreshing()
    }
  }
}

extension ProfilePreviewViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if posts != nil {
      return posts!.count + 1
    } else {
      return 1
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //Profile view
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileCell
      
      cell.user = self.user
      
      return cell
    }
    //Image cells
    else {
      let cell = tableView.dequeueReusableCellWithIdentifier("instagramCell", forIndexPath: indexPath) as! InstagramCell
      
      //First row is the profile information, so the instagram cells are offset by 1
      cell.post = posts![indexPath.row - 1]
      
      return cell
    }
  }
}