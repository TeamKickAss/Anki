//
//  ProfileViewController.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse
let logoutNotification = "logoutNotification"
class ProfileViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Logout(sender: AnyObject) {
        PFUser.logOut()
        
        NSNotificationCenter.defaultCenter().postNotificationName(logoutNotification, object: nil)
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
