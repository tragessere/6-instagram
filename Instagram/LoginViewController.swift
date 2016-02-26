//
//  LoginViewController.swift
//  Instagram
//
//  Created by Evan on 2/21/16.
//  Copyright © 2016 EvanTragesser. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      usernameField.delegate = self
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

  @IBAction func onSignInPress(sender: AnyObject) {
    PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) {
      (user: PFUser?, error: NSError?) -> Void in
        if user != nil {
          print("logged in")
          
          self.performSegueWithIdentifier("loginSegue", sender: nil)
        } else {
          print("error: \(error!.localizedDescription)")
        }
    }
  }
  
  @IBAction func onSignUpPress(sender: AnyObject) {
    let newUser = PFUser()
    
    newUser.username = usernameField.text
    newUser.password = passwordField.text
    
    newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
      if success {
        print("created new user")
        self.performSegueWithIdentifier("loginSegue", sender: nil)
      } else {
        print("new user error: \(error!.localizedDescription)")
      }
    }
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == usernameField {
      passwordField.becomeFirstResponder()
    }
    
    return true
  }
}
