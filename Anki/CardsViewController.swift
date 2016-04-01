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
    
    var deck: Deck?{
        didSet{
            getScheduler(deck!)
        }
    }
    var scheduler: Deck?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let htmlString:String! = "<br /><h2>Welcome to SourceFreeze!!!</h2>"
        webView.loadHTMLString(htmlString, baseURL: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getScheduler(deck: Deck){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
