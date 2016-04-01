//
//  UserDeckCell.swift
//  Anki
//
//  Created by Labuser on 3/24/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class UserDeckCell: UITableViewCell {

    @IBOutlet weak var deckName: UILabel!
    @IBOutlet weak var numChildrenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClick(sender: AnyObject) {
        
    }
}
