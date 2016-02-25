//
//  RecentsViewController.swift
//  Instagram
//
//  Created by Evan on 2/23/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var gradientView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.delegate = self
      tableView.dataSource = self
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
    return 1
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 5
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("instagramCell", forIndexPath: indexPath)
    
    return cell;
  }
  
  func didSubmitPhoto(image: UIImage!, caption: String?) {
    //TODO: make this do something
  }
}
