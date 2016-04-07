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

class CardTemplate: NSObject{
    var parseCardTemplate: PFObject
    
    init(cardTemplate: PFObject){
        parseCardTemplate = cardTemplate
    }
    
    var template: String{
        get{
            return parseCardTemplate.objectForKey("template") as! String
        }
        set(t){
            parseCardTemplate.setValue(t, forKey: "template")
        }
    }
}
class CardType: NSObject {
    var parseCardType: PFObject
    var FrontTemplate: CardTemplate
    var BackTemplate: CardTemplate
    
    init(cardType: PFObject){
        parseCardType = cardType
        FrontTemplate = CardTemplate(cardTemplate: cardType.objectForKey("FrontSide") as! PFObject)
        BackTemplate = CardTemplate(cardTemplate: cardType.objectForKey("BackSide") as! PFObject)
    }
    
    var FrontSide: String{
        get{
            return FrontTemplate.template
        }
    }
    
    var BackSide: String{
        get{
            return BackTemplate.template
        }
    }
}
class Card: NSObject {
    var parseCard: PFObject
    var cardType: CardType
    
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
    
    var notes: [[String]]{
        get{
            return parseCard.objectForKey("notes") as! [[String]]
        }
    }
    
    
    init(card: PFObject){
        parseCard = card
        print(card.objectForKey("gid"))
        cardType = CardType(cardType: card.objectForKey("CardType") as! PFObject)
    }
}
