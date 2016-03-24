//
//  TestViewCell.swift
//  Anki
//
//  Created by Labuser on 3/23/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class TestViewCell: UITableViewCell {

    @IBOutlet weak var deckName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
