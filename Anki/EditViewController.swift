//
//  EditViewController.swift
//  Anki
//
//  Created by Lily on 3/31/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    //let currentCard: Card //TODO

    @IBOutlet weak var frontText: UITextView!
    
    @IBOutlet weak var backText: UITextView!
    
    var card: Card?
    var deck: Deck?
    var scheduler: Scheduler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontText.text = card?.cardType.FrontSide
        backText.text = card?.cardType.BackSide
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        if frontText != nil && backText != nil {
            card?.cardType.FrontTemplate.template = frontText.text
            print(card?.cardType.FrontSide)
            card?.cardType.BackTemplate.template = backText.text
           
        }
        performSegueWithIdentifier("EditingToStudy", sender: self)
    }
    
//    
   @IBAction func cancel(sender: AnyObject) {
        performSegueWithIdentifier("EditingToStudy", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? CardsViewController{
            print("Editing View Controller")
            destination.currentCard = card
            destination.deck = deck
            destination.scheduler = scheduler
        }
    }
}
