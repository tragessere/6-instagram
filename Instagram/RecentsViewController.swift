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
  
  var userToSend: PFUser?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.delegate = self
      tableView.dataSource = self
      
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = UIScreen.mainScreen().bounds.width + 30
      
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
      tableView.insertSubview(refreshControl, atIndex: 0)
      
      refresh(refreshControl)
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
        let nc = segue.destinationViewController as! UINavigationController
        let vc = nc.topViewController as! SubmitViewController
        vc.delegate = self
      } else if segue.identifier == "profileSegue" {
        let vc = segue.destinationViewController as! ProfilePreviewViewController
        vc.user = userToSend
      }
      
    }
  
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
  

  @IBAction func didPressAdd(sender: AnyObject) {
  }
  
}

extension RecentsViewController: UITableViewDelegate, UITableViewDataSource, SubmitDelegate, InstagramCellHeaderDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if posts != nil {
      return posts!.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("instagramCell", forIndexPath: indexPath) as! InstagramCell
    
    cell.post = posts![indexPath.row]
    
    return cell;
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = InstagramCellHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
    
    headerView.post = posts![section]
    headerView.delegate = self
    
    return headerView
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
  func didPressProfile(user: PFUser?) {
    if user != nil {
      userToSend = user
      performSegueWithIdentifier("profileSegue", sender: self)
    }
  }
  
  func didSubmitPhoto(image: UIImage!, caption: String?) {
    //TODO: make this do something
  }
}
