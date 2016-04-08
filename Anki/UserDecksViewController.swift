//
//  UserDecksViewController.swift
//  Anki
//
//  Created by Labuser on 3/22/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit
import RATreeView
import Parse

class UserDecksViewController: UIViewController, RATreeViewDataSource, RATreeViewDelegate {

    private var treeView: RATreeView!
    private let xibName = "UserDeckCell"
    var data : [Deck] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DeckUtil.getAllDecks(200, withCompletion: {(decks: [Deck]?, error: NSError?) -> Void in
            if let decks = decks {
                self.data = decks
                self.treeView.reloadData()
            } else {
                //handle error
                print("error fetching data")
            }
        })
        
        treeView = RATreeView(frame: self.view.bounds)
        treeView.dataSource = self
        treeView.delegate = self
        
        treeView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue)
        treeView.backgroundColor = UIColor.clearColor()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(treeView)
        treeView.reloadData()
        treeView.registerNib(UINib(nibName: xibName, bundle: nil), forCellReuseIdentifier: xibName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func treeView(treeView: RATreeView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item = item as? Deck {
            let children = item.getChildren()
            return children.count
        } else {
            return self.data.count
        }
    }
    
    func treeView(treeView: RATreeView, cellForItem item: AnyObject?) -> UITableViewCell {
        let cell = treeView.dequeueReusableCellWithIdentifier(xibName) as! UserDeckCell
        let item = item as! Deck
        let level = treeView.levelForCellForItem(item)
        let spaces = String(count: (2 * level), repeatedValue: (" " as! Character))
        cell.deckName.text = spaces + item.name
        if item.children != nil {
            cell.numChildrenLabel.text = spaces + "# of children: " + String(item.children!.count)
        } else {
            cell.numChildrenLabel.text = spaces + "# of children: " + "0"
        }
        cell.deck = item
        cell.vc = self
        return cell
    }
    
    func treeView(treeView: RATreeView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let item = item as? Deck {
            return item.getChildren()[index] as AnyObject
        } else {
            return data[index] as AnyObject
        }
    }

    @IBAction func onProfileClick(sender: AnyObject) {
        performSegueWithIdentifier("Profile", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("in prepare to segue")
        if let identifier = segue.identifier{
            switch identifier{
            case "Study":
                let cell = sender as! UserDeckCell
                let destination = segue.destinationViewController as! CardsViewController
                destination.deck = cell.deck
                break
                
            case "Profile":
                print("going to profile")
                break
                
            default:
                break
            }
        }
        
    }

}
