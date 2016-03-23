//
//  Transaction.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

class Transaction: NSObject {
    
    
    
    class func ApplyTransactions(thing: PFObject, transactions: [PFObject]?, withCompletion completion:
        PFBooleanResultBlock?){
            if let trans = transactions{
                if trans.isEmpty {
                    if let c = completion   {
                        c(false, nil)
                    }
                }
                var callbacks = [PFBooleanResultBlock]()
                for t in trans{
                    let query = t.objectForKey("query") as! String
                    let on = t.objectForKey("for") as! String
                    
                    switch(on){
                        case "Deck":
                            let deck = thing
                            switch(query){
                                case "ADD":
                                    let json = try NSJSONSerialization.JSONObjectWithData(t.objectForKey("data") as! NSData, options: NSJSONReadingOptions.AllowFragments)
                                    if let gid = json["gid"] as? String{
                                        deck.addObject("gid", gid)
                                    }
                                break
                                case "REMOVE"
                                }
                            
                            break
                        default:
                        continue
                    }
                }
            }
    }

}