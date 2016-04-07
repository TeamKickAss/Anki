//
//  CardsViewController.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var GoodButton: UIButton!
    @IBOutlet weak var EasyButton: UIButton!
    
    var deck: Deck?
    var showingFront = false
    var scheduler: Scheduler?
    var currentCard: Card?
    override func viewDidLoad() {
        super.viewDidLoad()
        let htmlString:String! = "<br /><h2>Loading Your Deck</h2>"
        webView.loadHTMLString(htmlString, baseURL: nil)
        if scheduler == nil{
            getScheduler(deck!)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if currentCard != nil{
            renderFront()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getScheduler(deck: Deck){
        print("In Get Scheduler")
        scheduler = Scheduler(deck: deck, onStatusChange: schedulerStatusChange)
        print("Got Scheduler")
        scheduler?.loadCards()
    }
    
    func schedulerStatusChange(status: SchedulerStatus){
        print("In Scheduler Status Change \(status)")
        switch status{
        case SchedulerStatus.Ready:
            currentCard = scheduler?.getNextCard()
            renderFront()
            break
        case SchedulerStatus.Initializing:
            break
        case SchedulerStatus.Done:
            break
        case SchedulerStatus.OutOfCards:
            break
        case SchedulerStatus.Error:
            break
        }
    }
    
    func renderFront(){
        print("Render Front")
        if currentCard != nil{
            webView.loadHTMLString(currentCard!.cardType.FrontSide, baseURL: nil)
        }
        showingFront = true
    }
    
    func renderBack(){
        print("Render Back")
        if currentCard != nil{
            webView.loadHTMLString(currentCard!.cardType.BackSide, baseURL: nil)
        }
        showingFront = false
    }

    @IBAction func Flip(sender: AnyObject) {
        if showingFront{
            renderBack()
        }else{
            renderFront()
        }
    }
    @IBAction func Again(sender: AnyObject) {
        scheduler?.setLastCard(.Again)
        currentCard = scheduler?.getNextCard()
        renderFront()
    }
    @IBAction func Hard(sender: AnyObject) {
        scheduler?.setLastCard(.Hard)
        currentCard = scheduler?.getNextCard()
        renderFront()
    }
    @IBAction func Good(sender: AnyObject) {
        scheduler?.setLastCard(.Good)
        currentCard = scheduler?.getNextCard()
        renderFront()
    }
    @IBAction func Easy(sender: AnyObject) {
        scheduler?.setLastCard(.Easy)
        currentCard = scheduler?.getNextCard()
        renderFront()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as? EditViewController{
            print("Editing View Controller")
            destination.card = currentCard
            destination.deck = deck
            destination.scheduler = scheduler
        }
    }
    
    

}
