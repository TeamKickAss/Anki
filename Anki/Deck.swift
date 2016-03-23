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
    
    // getDecks : Tries to get all the decks with a given gid. Check to make sure the size of the array of decks given is the size of the array of gids sent. 
    class func getDecks(gids: [String], withCompletion completion: PFQueryArrayResultBlock){
        var callbacks = [PFQueryArrayResultBlock]()
        var decks = [PFObject]()
        var numDone = 0
        let numFinished = gids.count
        if (gids.isEmpty){
            return completion(decks, nil)
        }
        let finished = {() ->() in
            if (numDone == numFinished){
                completion(decks, nil)
            }else{
                numDone = numDone + 1
            }
        }
        for gid in gids {
            let query = PFQuery(className: "Deck")
            let callback = { (results: [PFObject]?, e: NSError?) -> () in
                if(e != nil){
                    if let deck = results?[0]{
                        decks.append(deck)
                    }
                }
                finished()
            }
            callbacks.append(callback)
            query.whereKey("gid", equalTo: gid)
            query.findObjectsInBackgroundWithBlock(callback)
            
        }
        
    }
    
    class func getCardsForDeck(deck: PFObject, withCompletion completion: PFQueryArrayResultBlock){
        var callbacks = [PFQueryArrayResultBlock]()
        var cards = [PFObject]()
        var gids = deck.objectForKey("cids") as? [String]
        if let gids = gids{
            if gids.isEmpty{
                return completion(cards, nil)
            }
        }else{
            return completion(cards, nil)
        }
        
        var numDone = 0
        let numFinished = gids!.count
        let finished = {() ->() in
            if (numDone == numFinished){
                completion(cards, nil)
            }else{
                numDone = numDone + 1
            }
        }
        for gid in gids! {
            let query = PFQuery(className: "Card")
            let callback = { (results: [PFObject]?, e: NSError?) -> () in
                if(e != nil){
                    if let card = results?[0]{
                        cards.append(card)
                    }
                }
                finished()
            }
            callbacks.append(callback)
            query.whereKey("gid", equalTo: gid)
            query.findObjectsInBackgroundWithBlock(callback)
            
        }
    }
}
