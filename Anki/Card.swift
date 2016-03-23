//
//  Card.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

class Card: NSObject {
    
    class func getCardWithGid(gid: String, withCompletion completion: PFBooleanResultBlock?){
        let query = PFQuery(className: "Card")
        query.whereKey("gid", equalTo: gid)
        query.findObjectsInBackgroundWithBlock { (objs: [PFObject]?, error: NSError?) -> Void in
            if c = completion{
                c(objs, error)
            }
        }
        
    }
}
