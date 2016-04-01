//
//  LoginViewController.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func onLogin(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user:PFUser?, error:NSError?) -> Void in
            if user != nil{
                print("logged in")
                self.performSegueWithIdentifier("StartSegue", sender: nil)
            }else{
                print("not logged in")
            }
        }
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser =  PFUser()
        newUser.username = username.text!
        newUser.password = password.text!
        newUser.signUpInBackgroundWithBlock { (success:Bool, error: NSError?) -> Void in
            if success{
                print("Yay, created a user!")
                self.performSegueWithIdentifier("StartSegue", sender: nil)
            }else{
                print(error?.localizedDescription)
                if error?.code == 202{
                    print ("Username is taken")
                }
                
                
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
