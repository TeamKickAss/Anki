//
//  CardsViewController.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tabBar: UITabBar!
    
    var deck: Deck?
    var showingFront = false
    var scheduler: Scheduler?
    var currentCard: Card?
    override func viewDidLoad() {
        super.viewDidLoad()
        let htmlString:String! = "<br /><h2>Loading Your Deck</h2>"
        webView.loadHTMLString(htmlString, baseURL: nil)
        getScheduler(deck!)
        tabBar.delegate = self
        
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
        print("Loading Cards")
    }
    
    func schedulerStatusChange(status: SchedulerStatus){
        print("In Scheduler Status Change \(status)")
        switch status{
        case SchedulerStatus.Ready:
            currentCard = scheduler?.getNextCard(nil)
            renderFront()
            break
        case SchedulerStatus.Initializing:
            break
        case SchedulerStatus.Done:
            break
        case SchedulerStatus.OutOfCards:
            alert("This is the last card in the deck!")
            break
        case SchedulerStatus.Error:
            break
        }
    }
    
    func renderFront(){
        if currentCard != nil{
            print(currentCard!.RenderFront())
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.webView.alpha = 0
            }, completion: {(finished: Bool) in
                self.webView.loadHTMLString(self.currentCard!.RenderFront(), baseURL: nil)
                UIView.animateWithDuration(0.5) {
                    self.webView.alpha = 1
                }
            })
        }
        showingFront = true
    }
    
    func renderBack(){
        print("Render Back \(currentCard!.RenderBack())")
        if currentCard != nil{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.webView.alpha = 0
            }, completion: {(finished: Bool) in
                self.webView.loadHTMLString(self.currentCard!.RenderBack(), baseURL: nil)
                UIView.animateWithDuration(0.5) {
                    self.webView.alpha = 1
                }
            })
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
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag==0) {
            print("again")
            currentCard = scheduler?.getNextCard(.Again)
        } else if (item.tag==1) {
            print("hard")
            currentCard = scheduler?.getNextCard(.Hard)
        } else if (item.tag==2) {
            print("good")
            currentCard = scheduler?.getNextCard(.Good)
        } else {
            print("easy")
            currentCard = scheduler?.getNextCard(.Easy)
        }
        renderFront()
        
        let delay = 0.25 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            tabBar.selectedItem = nil
        }
    }
    
    func alert(msg:String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        scheduler?.save()
        if let destination = segue.destinationViewController as? EditViewController{
            print("Editing View Controller")
            destination.card = currentCard
            destination.deck = deck
            destination.scheduler = scheduler
        }
    }
    
    

}
