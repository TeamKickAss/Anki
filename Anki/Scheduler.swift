//
//  Scheduler.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import Parse

enum CardDifficulty: Int{
    case New = 0
    case Easy = 1
    case Good = 2
    case Hard = 3
    case Again = 4
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

var pseudoRandomNum = 0
class Scheduler: NSObject {
    
    //Scheduling Options
    var cardsPerDay = 30
    var numStudied = 0
    //In seconds
    var timeAgainHard = 60.0
    var timeAgainGood = 600.0
    var timeAgainEasy = 86400.0
    
    var difficultyCount = [Int](count: 5, repeatedValue: 0)
    
    var deck: Deck?
    var rootCard: CardNode? //List of cards that haven't been studied yet. Card is studied when it is marked easy.
    var lastCard: CardNode?
    var cardHeapSize: Int
    var cardHeap: [CardNode?]
    var cardHeapPosition: Int
    
    var doneList: [CardNode?] //List of cards that you've done studying
    
    
    var status = SchedulerStatus.Initializing{
        didSet{
            onStatusChange(status: status)
        }
    }
    var onStatusChange: (status: SchedulerStatus) -> Void
    
    init(deck: Deck, onStatusChange: (status: SchedulerStatus) -> Void){
        self.cardHeap = [CardNode]()
        self.doneList = [CardNode]()
        self.cardHeapSize = 0
        self.cardHeapPosition = 0
        self.onStatusChange = onStatusChange
        self.deck = deck;
        super.init()
        
    }
    
    //***************************
    //HEAP Functions
    //***************************
    
    
    func insert(cN: CardNode){
        if(cardHeapPosition == 0){
            cardHeap[cardHeapPosition+1] = cN
            cardHeapPosition = 2;
        }else{
            cardHeap[cardHeapPosition++]=cN
            bubbleUp();
        }
    }
    
    func bubbleUp(){
        var pos = cardHeapPosition-1
        

        var a = cardHeap[pos/2]
        var b = cardHeap[pos]
        
        while(pos>0 && a != nil && b != nil && cardHeap[pos/2]!.isLessThan(cardHeap[pos]!)){
            var y = cardHeap[pos]
            b = cardHeap[pos/2]
            a = y
        }
    }
    
    func extractMax() -> CardNode?{
        if cardHeapPosition > 0 || cardHeapPosition < cardHeap.count{
            let node = cardHeap[1]
            cardHeap[1] = cardHeap[cardHeapPosition-1]
            cardHeap[cardHeapPosition-1]=nil
            cardHeapPosition--
            sinkDown(1)
            return node
        }
        return nil
    }
    
    func sinkDown(k: Int){
        var smallest = k
        if(2*k<cardHeapPosition && cardHeap[smallest]!.isLessThan(cardHeap[2*k]!)){
            smallest = 2*k
        }
        if(2*k+1<cardHeapPosition && cardHeap[smallest]!.isLessThan(cardHeap[2*k+1]!)){
            smallest = 2*k+1
        }
        if(smallest != k){
            swap(k, b: smallest);
            sinkDown(smallest)
        }
    }
    func swap(a: Int, b:Int){
        var temp = cardHeap[a]
        cardHeap[a] = cardHeap[b]
        cardHeap[b] = temp
    }
    /***********
    Card Functions
    **********/
    func loadCards(){
        DeckUtil.getCardsForDeck(deck!, withCompletion: self.gotNewCards)
    }
    
    func gotNewCards(cards: [Card]?, error: NSError?){
        print("Got new cards")
        if let cards = cards{
            if !cards.isEmpty{
                cardHeap = [CardNode?](count: cards.count+1, repeatedValue: nil)
                cardHeapSize = cards.count+1
                doneList = [CardNode?]()
                difficultyCount = [Int](count: 5, repeatedValue: 0)
                difficultyCount[CardDifficulty.New.rawValue] = cards.count
                var i = 0
                for ; i < cards.count; i = i+1{
                    insert(CardNode(card: cards[i], index:i, difficulty: .New))
                }
                lastCard = cardHeap[i-1]
            }
        }
        status = .Ready
    }
    
    func listLength(node: CardNode) -> Int{
        var len = 0
        for c in cardHeap{
            if c != nil{
                len++
            }
        }
        return len
        
    }
    
    func save(){
        
    }
    
    func load(){
        
    }
    
    func getNextCard(difficulty: CardDifficulty?) -> Card?{
        if lastCard != nil && difficulty != nil{
            difficultyCount[(lastCard?.difficulty.rawValue)!]--
            difficultyCount[difficulty!.rawValue]++
            numStudied = numStudied + 1
            lastCard?.difficulty = difficulty!
            //ADD IT TO THE NEW LIST
            if difficulty == .Easy{
                doneList.append(lastCard)
            }else{
                insert(lastCard!)
            }
        }
        print("Hello")
        if status != .OutOfCards{
            lastCard = extractMax()
            if lastCard == nil{
                print("Returning Nothing")
                status = .OutOfCards
                return nil
            }
            lastCard?.status = .Viewed
            return lastCard?.card
        }else{
            status = .OutOfCards
            return lastCard?.card
        }
        
    }
    
    func getDifficultyCount(difficulty: CardDifficulty)->Int{
        return difficultyCount[difficulty.rawValue]
    }
    
    // shuffle Maintains Following Properties
    // New Cards always at the end
    // Hard Cards usually before Good Cards
    
    class CardNode {
        let index: Int
        let card: Card
        var difficulty: CardDifficulty
        var status: CardStatus
        var lastViewed: NSDate?
        init(card: Card, index: Int, difficulty: CardDifficulty){
            self.card = card
            self.difficulty = difficulty
            self.status = .Waiting
            self.index = index
        }
        
        func equals(card: CardNode) -> Bool{
            return self.index == card.index
        }
        
        func isLessThan(card: CardNode) ->Bool{
            if self.difficulty.rawValue == card.difficulty.rawValue{
                return false
            }
            switch card.difficulty{
            case .New:
                return true
            case .Easy:
                return true
            case .Good:
                if pseudoRandomNum++ % 3 == 0{
                    return false
                }
                return self.difficulty.rawValue < card.difficulty.rawValue
            case .Hard:
                if pseudoRandomNum++ % 2 == 0{
                    return false
                }
                return self.difficulty.rawValue < card.difficulty.rawValue
            case .Again:
                return false
            }
        }
    }
}


