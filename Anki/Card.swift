//
//  Card.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

//Immutable.
class Card: NSObject {
    var parseCard: PFObject
    
    var gid: String{
        get{
            return parseCard.objectForKey("gid") as! String
        }
    }
    
    var did: String{
        get{
            return parseCard.objectForKey("did") as! String
        }
    }
    
    var owner: String{
        get{
            return parseCard.objectForKey("owner") as! String
        }
    }
    
    var cid: String{
        get{
            return parseCard.objectForKey("cid") as! String
        }
    }
    
    var front: String{
        get{
            return parseCard.objectForKey("front") as! String
        }
        set(text){
            self.front = text;
        }
    }
    
    var back: String{
        get{
            return parseCard.objectForKey("back") as! String
        }
        set(text){
            self.back = text;
        }
    }
    
    init(card: PFObject){
        parseCard = card
    }
}
