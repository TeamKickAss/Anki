//
//  User.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
class User: NSObject {
    static var myDecks = [PFObject]()
    static var myDecksGids = [String]()
    class func updateMyDecks(withCompletion completion: PFBooleanResultBlock){
        let user = PFUser.currentUser()
        let gids = user?.objectForKey("decks") as! [String]
        Deck.getDecks(gids) { (decks: [PFObject]?, error: NSError?) -> Void in
            if let decks = decks{
                if gids.count != decks.count{
                    print("Error: Failed to get every User Deck")
                }
                myDecksGids = [String]()
                for d in decks{
                    myDecksGids.append(d.objectForKey("gid") as! String)
                }
                myDecks = decks
                completion(true, error)
            }
        }
    }
}