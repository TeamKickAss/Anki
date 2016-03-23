//
//  Scheduler.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

enum CardDifficulty{
    case Again
    case Hard
    case Good
    case Easy
    case New
}

enum CardStatus{
    case Viewed
    case Waiting
}

enum SchedulerStatus{
    case Ready
    case Initializing
    case Done
    case OutOfCards
    case Error
}

class Scheduler: NSObject {
    
    var rootCard: CardNode?
    var lastCard: CardNode?
    var currentCard: CardNode?
    var cardArr: [CardNode]
    var status = SchedulerStatus.Initializing{
        didSet{
            onStatusChange(status: status)
        }
    }
    var onStatusChange: (status: SchedulerStatus) -> Void
    init(deck: PFObject, onStatusChange: (status: SchedulerStatus) -> Void){
        self.cardArr = [CardNode]()
        self.onStatusChange = onStatusChange
        super.init()
        Deck.getCardsForDeck(deck, withCompletion: self.gotNewCards)
        
    }
    
    func gotNewCards(cards: [PFObject]?, error: NSError?){
        if let cards = cards{
            if !cards.isEmpty{
                cardArr = [CardNode]()
                var i = 0
                for ; i < cards.count; i = i+1{
                    if i == 0 {
                        cardArr.append(CardNode(card: cards[i], index: i, difficulty: .New, prev: nil, next: nil))
                        rootCard = cardArr[i]
                        currentCard = cardArr[i]
                    }else{
                        cardArr.append(CardNode(card: cards[i], index: i, difficulty: .New, prev: cardArr[i-1] , next: nil))
                        cardArr[i-1].next = cardArr[i]
                    }
                }
                lastCard = cardArr[i-1]
            }
        }
        status = .Ready
    }
    
    func getNextCard() -> PFObject?{
        let card = currentCard?.card
        lastCard = currentCard
        lastCard?.status = .Viewed
        if currentCard?.next == nil{
            status = .OutOfCards
        }else{
            currentCard = currentCard?.next
        }
        return card
    }
    
    func setLastCard(difficulty: CardDifficulty){
        lastCard?.difficulty = difficulty
        if(difficulty == .Easy){
            if let prev = lastCard?.prev{
                prev.next = lastCard?.next
            }
            
            if let next = lastCard?.next{
                next.prev = lastCard?.prev
            }
        }
    }
    
    // shuffle Maintains Following Properties
    // New Cards always at the end
    // Hard Cards usually before Good Cards
    func shuffle(from: CardNode, to: CardNode){
        //Do nothing for now.
    }
    
    class CardNode {
        let index: Int
        let card: PFObject
        var difficulty: CardDifficulty
        var prev: CardNode?
        var next: CardNode?
        var status: CardStatus
        var lastViewed: NSDate?
        init(card: PFObject, index: Int, difficulty: CardDifficulty, prev: CardNode?, next: CardNode?){
            self.card = card
            self.difficulty = difficulty
            self.prev = prev
            self.next = next
            self.status = .Waiting
            self.index = index
        }
        
        func equals(card: CardNode) -> Bool{
            return self.index == card.index
        }
    }
}

