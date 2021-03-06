//
//  RecentsViewController.swift
//  Instagram
//
//  Created by Evan on 2/23/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import MBProgressHUD
import JTSImageViewController
import Parse

class RecentsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  var posts: [InstagramPost]?
  var refreshControl: UIRefreshControl!
  var userToSend: PFUser?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.delegate = self
      tableView.dataSource = self
      
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = UIScreen.mainScreen().bounds.width + 30
      
      refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
      tableView.insertSubview(refreshControl, atIndex: 0)
      
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)
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
//        print("data: \(response!)")
        self.posts = InstagramPost.postsWithArray(response!)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
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

extension RecentsViewController: UITableViewDelegate, UITableViewDataSource, SubmitDelegate, InstagramCellDelegate, InstagramCellHeaderDelegate {
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
    
    cell.post = posts![indexPath.section]
    cell.delegate = self
    
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
    refresh(refreshControl)
    //TODO: make this do something
  }
  
  func didTapImage(imageView: UIImageView) {
    let imageInfo = JTSImageInfo()
    imageInfo.image = imageView.image
    imageInfo.referenceView = self.parentViewController?.parentViewController?.view
    
    let absoluteOrigin = self.parentViewController?.view.convertPoint(imageView.frame.origin, fromView: imageView.superview)
    var startingFrame = imageView.frame
    startingFrame.origin = absoluteOrigin!
    imageInfo.referenceRect = startingFrame
    
    let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
    
    imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOriginalPosition)
  }
}
