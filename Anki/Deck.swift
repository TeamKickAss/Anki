//
//  Deck.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

class Deck: NSObject{
    var parseDeck: PFObject
    var gid: String{
        set(value){
            parseDeck.setObject(value, forKey: "gid")
        }
        get{
            return parseDeck.objectForKey("gid") as! String
        }
    }
    
    var did: String{
        set(value){
            parseDeck.setObject(value, forKey: "did")
        }
        get{
            return parseDeck.objectForKey("did") as! String
        }
    }
    var name: String{
        set(value){
            parseDeck.setObject(value, forKey: "name")
        }
        get{
            return parseDeck.objectForKey("name") as! String
        }
    }
    
    var owner: String{
        set(value){
            parseDeck.setObject(value, forKey: "owner")
        }
        get{
            return parseDeck.objectForKey("owner") as! String
        }
    }
    
    var desc: String{
        set(value){
            parseDeck.setObject(value, forKey: "description")
        }
        get{
            return parseDeck.objectForKey("description") as! String
        }
    }
    
    var cids: [String]?{
        set(value){
            parseDeck.setObject(value!, forKey: "cids")
        }
        get{
            return parseDeck.objectForKey("cids") as? [String]
        }
    }
    
    var children: [String]?{
        set(value){
            parseDeck.setObject(value!, forKey: "children")
        }
        get{
            return parseDeck.objectForKey("children") as? [String]
        }
    }
    
    init(deck: PFObject){
        parseDeck = deck
    }
    
    func getChildren()->[Deck]{
        if children == nil {
            return []
        }
        let query = PFQuery(className: "Deck")
        query.whereKey("gid", containedIn: children!)
        let results = try? query.findObjects()
        var decks = [Deck]()
        if let results = results{
            for d in results{
                decks.append(Deck(deck: d))
            }
        }
        return decks
    }
    func save(block: PFBooleanResultBlock?){
        parseDeck.saveInBackgroundWithBlock(block)
    }
}

class DeckUtil: NSObject {
    
    // getDecks : Tries to get all the decks with a given gid. Check to make sure the size of the array of decks given is the size of the array of gids sent. 
    class func getAllDecks(limit: Int, withCompletion completion: ([Deck]?, NSError?) -> Void){
        let query = PFQuery(className: "Deck")
        query.limit = limit
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            if let objs = objs{
                var decks = [Deck]()
                for d in objs{
                    decks.append(Deck(deck: d))
                }
                completion(decks, nil)
                
            }
            completion(nil, nil)
        }
    }
    class func getDecksSync(gids: [String])-> [Deck]{
        let query = PFQuery(className: "Deck")
        query.whereKey("gid", containedIn: gids)
        let results = try? query.findObjects()
        var decks = [Deck]()
        if let results = results{
            for d in results{
                decks.append(Deck(deck: d))
            }
        }
        return decks
    }
    class func getDecks(var gids: [String], withCompletion completion: ( [Deck]?, NSError?) -> Void){
        var callbacks = [PFQueryArrayResultBlock]()
        var decks = [Deck]()
        var numDone = 0
        if (gids.isEmpty){
            return completion(decks, nil)
        }
        let finished = {() ->() in
            numDone = numDone + 1
            if (numDone >= gids.count){
                completion(decks, nil)
            }
        }
        for gid in gids {
            let query = PFQuery(className: "Deck")
            let callback = { (results: [PFObject]?, e: NSError?) -> () in
                if(e != nil){
                    if let deck = results?[0]{
                        let d = Deck(deck: deck)
                        if let cld = d.children{
                            gids = gids + cld
                        }
                        decks.append(d)
                    }
                }
                finished()
            }
            callbacks.append(callback)
            query.whereKey("gid", equalTo: gid)
            query.findObjectsInBackgroundWithBlock(callback)
            
        }
        
    }
    
    class func getCardsForDeck(deck: Deck, withCompletion completion: ( [Card]?, NSError?) -> Void){
        var callbacks = [PFQueryArrayResultBlock]()
        var cards = [Card]()
        let gids = deck.cids
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
                        cards.append(Card(card: card))
                    }
                }
                finished()
            }
            callbacks.append(callback)
            query.whereKey("gid", equalTo: gid)
            query.findObjectsInBackgroundWithBlock(callback)
            
        }
    }
    
    class func getChildrenDecksForDeck(deck: Deck, withCompletion completion:( [Deck]?, NSError?) -> Void){
        let gids = deck.children
        if let gids = gids{
            getDecks(gids, withCompletion: completion)
        }else{
            completion([], nil)
        }
    }
}
