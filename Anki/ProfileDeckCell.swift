//
//  ProfileDeckCell.swift
//  Anki
//
//  Created by Labuser on 4/7/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class ProfileDeckCell: UITableViewCell {

    @IBOutlet weak var deckName: UILabel!
    @IBOutlet weak var numCardsLabel: UILabel!
    @IBOutlet weak var numChildrenLabel: UILabel!
    
    var vc: UIViewController?
    var deck: Deck?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
