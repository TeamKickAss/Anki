//
//  Deck.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse
class Deck: NSObject {

    class func getDecks(gids: [String], withCompletion completion: PFBooleanResultBlock){
        var callbacks = [PFBooleanResultBlock]()
        for gid in gids {
            let query = PFQuery(className: "Deck")
            query.whereKey("gid", equalTo: gid)
            
        }
        
    }
}
