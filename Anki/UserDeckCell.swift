//
//  UserDeckCell.swift
//  Anki
//
//  Created by Labuser on 3/24/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class UserDeckCell: UITableViewCell {

    @IBOutlet weak var deckName: UILabel!
    @IBOutlet weak var numCardsLabel: UILabel!
    @IBOutlet weak var numChildrenLabel: UILabel!
    
    var vc: UIViewController?
    var deck: Deck?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClick(sender: AnyObject) {
        print("Study button pressed")
        vc?.performSegueWithIdentifier("Study", sender: self)
    }
    
    @IBAction func onSync(sender: AnyObject) {
        print("\(deck?.children)")
        print("Sync button pressed")
        deck?.sync({ (success: Bool, error: NSError?) -> Void in
            if success {
                // create the alert
                let alert = UIAlertController(title: "Sync Complete", message: "\(self.deckName.text!) has synced to server.", preferredStyle: UIAlertControllerStyle.Alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
                // show the alert
                self.vc?.presentViewController(alert, animated: true, completion: nil)
            } else {
                print("Error: \(error)")
            }
        })
    }
}
