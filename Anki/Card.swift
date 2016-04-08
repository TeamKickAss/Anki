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
    var didChange = false
    
    init(cardTemplate: PFObject){
        
        parseCardTemplate = cardTemplate
    }
    
    var template: String{
        get{
            return parseCardTemplate.objectForKey("template") as! String
        }
        set(t){
            parseCardTemplate.setValue(t, forKey: "template")
            didChange = true
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
    
    var notes: [String:String]{
        get{
            return parseCard.objectForKey("notes") as! [String:String]
        }
        set(n){
            parseCard.setValue(n, forKey: "notes")
        }
    }
    
    
    init(card: PFObject){
        
        parseCard = card
        print(card.objectForKey("gid"))
        cardType = CardType(cardType: card.objectForKey("CardType") as! PFObject)
        
    }
    
    func RenderFront() -> String{
        var s = String(cardType.FrontSide)
        var org = String(cardType.FrontSide)
        var replaceWith:String = ""
        var replacementLength = replaceWith.characters.count
        var err: NSError? = nil
        var expr = try! NSRegularExpression(pattern: "\\{\\{(\\w+)\\}\\}", options: .CaseInsensitive)
        let matches = expr.matchesInString(s, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, s.characters.count) )
            var replacedStringLengthDifference = 0
            for match in matches {
                replaceWith = getNote((org as NSString).substringWithRange(match.rangeAtIndex(1)))
                let startIndex =  s.startIndex.advancedBy(match.range.location + replacedStringLengthDifference)
                var endIndex = s.startIndex.advancedBy(match.range.length + match.range.location + replacedStringLengthDifference)
                replacedStringLengthDifference -= (match.range.length - replacementLength)
                s.replaceRange(startIndex..<endIndex, with: replaceWith)
            }
        
        return s
    }
    
    func getNote(key: String) -> String{
        if(key == "FrontSide"){
            return RenderFront()
        }
        let n = notes[key]
        if n == nil{
            print("Returning empty key")
            return " "
        }else{
            print("Returning key: \(key), value: \(n)")
           return n!
        }
    }
    
    func RenderBack() -> String{
        var s = String(cardType.BackSide)
        var org = String(cardType.BackSide)
        var replaceWith:String = ""
        var replacementLength = replaceWith.characters.count
        var err: NSError? = nil
        var expr = try! NSRegularExpression(pattern: "\\{\\{(\\w+)\\}\\}", options: .CaseInsensitive)
        
        let matches = expr.matchesInString(s, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, s.characters.count) )
        var replacedStringLengthDifference = 0
        for match in matches {
            replaceWith = getNote((org as NSString).substringWithRange(match.rangeAtIndex(1)))
            let startIndex =  s.startIndex.advancedBy(match.range.location + replacedStringLengthDifference)
            var endIndex = s.startIndex.advancedBy(match.range.length + match.range.location + replacedStringLengthDifference)
            replacedStringLengthDifference -= (match.range.length - replacementLength)
            s.replaceRange(startIndex..<endIndex, with: replaceWith)
        }
        
        return s
    }
    
    func GetChanges(indexGroup: NSString, index: Int)->[PFObject]{
        var i = index
        var toReturn = [PFObject]()
        if cardType.BackTemplate.didChange{
            let t1 = PFObject(className: "Transaction")
            t1.setValue(gid, forKey: "on")
            t1.setValue("Card", forKey: "for")
            t1.setValue(PFUser.currentUser()?.username, forKey: "owner")
            t1.setValue(indexGroup, forKey: "indexGroup")
            t1.setValue(index, forKey: "index")
            t1.setValue(["back":cardType.BackSide], forKey: "data")
            t1.setValue("cBACK", forKey: "query")
            i++
            toReturn.append(t1)
        }
        
        if cardType.BackTemplate.didChange{
            let t2 = PFObject(className: "Transaction")
            t2.setValue(gid, forKey: "on")
            t2.setValue("Card", forKey: "for")
            t2.setValue(PFUser.currentUser()?.username, forKey: "owner")
            t2.setValue(indexGroup, forKey: "indexGroup")
            t2.setValue(index, forKey: "index")
            t2.setValue(["front":cardType.FrontSide], forKey: "data")
            t2.setValue("cFRONT", forKey: "query")
            toReturn.append(t2)
        }
        return toReturn
        
    }
}
