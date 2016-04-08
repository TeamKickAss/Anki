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
    static var myDecks = [Deck]()
    static var myDecksGids = [String]()
    class func updateMyDecks(withCompletion completion: PFBooleanResultBlock){
        let user = PFUser.currentUser()
        let gids = user?.objectForKey("decks") as! [String]
        DeckUtil.getDecks(gids) { (decks: [Deck]?, error: NSError?) -> Void in
            if let decks = decks{
                if gids.count != decks.count{
                    print("Error: Failed to get every User Deck")
                }
                myDecksGids = [String]()
                for d in decks{
                    myDecksGids.append(d.gid)
                }
                myDecks = decks
                completion(true, error)
            }
        }
    }
    class func getMyDecks(withCompletion completion: (decks: [Deck]?, error: NSError?) -> Void){
        let gids = PFUser.currentUser()?.objectForKey("decks") as? [String]
        print(gids)
        DeckUtil.getDecks(gids!, withCompletion: completion)
    }
}