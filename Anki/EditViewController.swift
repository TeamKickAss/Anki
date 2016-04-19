//
//  EditViewController.swift
//  Anki
//
//  Created by Lily on 3/31/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        card?.cardType.FrontTemplate.template = frontText.text
        card?.cardType.BackTemplate.template = backText.text
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        card?.save({ (worked, err) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            print("Was Able to Save Transactions: \(worked), \(err)")
            self.dismissViewControllerAnimated(true, completion: nil)
        })
           
        //performSegueWithIdentifier("EditingToStudy", sender: self)
        
    }
    
   @IBAction func cancel(sender: AnyObject) {
        //performSegueWithIdentifier("EditingToStudy", sender: self)
        dismissViewControllerAnimated(true, completion: nil)
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
