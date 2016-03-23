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
    static let myDecks = [PFObject]()
    class func updateMyDecks(withCompletion completion: PFBooleanResultBlock){
        let user = PFUser.currentUser()
        let decks = user?.objectForKey("decks")
        Deck.getDecks(decks)
    }
}