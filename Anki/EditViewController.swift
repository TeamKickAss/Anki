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
    
    
    @IBAction func onSubmit(sender: AnyObject) {
        if frontText != nil && backText != nil {
            //currentCard.front = frontText.text;
            //currentCard.back = backText.text;
            
        }
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
    }
}
