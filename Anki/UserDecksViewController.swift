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

    @IBOutlet weak var deckTree: RATreeView!
    private var treeView: RATreeView!
    private let xibName = "UserDeckCell"
    var data : [Deck] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //data = UserDecksViewController.commonInit()
        
        DeckUtil.getAllDecks(20, withCompletion: {(decks: [Deck]?, error: NSError?) -> Void in
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
        return cell
    }
    
    func treeView(treeView: RATreeView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let item = item as? Deck {
            return item.getChildren()[index] as AnyObject
        } else {
            return data[index] as AnyObject
        }
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

private extension UserDecksViewController {

    static func commonInit() -> [DeckNode] {
        let phone1 = DeckNode(name: "Phone 1")
        let phone2 = DeckNode(name: "Phone 2")
        let phone3 = DeckNode(name: "Phone 3")
        let phone4 = DeckNode(name: "Phone 4")
        let phones = DeckNode(name: "Phones", children: [phone1, phone2, phone3, phone4])

        let notebook1 = DeckNode(name: "Notebook 1")
        let notebook2 = DeckNode(name: "Notebook 2")

        let computer1 = DeckNode(name: "Computer 1", children: [notebook1, notebook2])
        let computer2 = DeckNode(name: "Computer 2")
        let computer3 = DeckNode(name: "Computer 3")
        let computers = DeckNode(name: "Computers", children: [computer1, computer2, computer3])

        let cars = DeckNode(name: "Cars")
        let bikes = DeckNode(name: "Bikes")
        let houses = DeckNode(name: "Houses")
        let flats = DeckNode(name: "Flats")
        let motorbikes = DeckNode(name: "motorbikes")
        let drinks = DeckNode(name: "Drinks")
        let food = DeckNode(name: "Food")
        let sweets = DeckNode(name: "Sweets")
        let watches = DeckNode(name: "Watches")
        let walls = DeckNode(name: "Walls")

        return [phones, computers, cars, bikes, houses, flats, motorbikes, drinks, food, sweets, watches, walls]
    }

}
