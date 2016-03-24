//
//  DeckNode.swift
//  Anki
//
//  Created by Labuser on 3/23/16.
//  Copyright © 2016 TeamKickAss. All rights reserved.
//

import UIKit

class DeckNode: NSObject {
    let name : String
    private(set) var children : [DeckNode]

    init(name : String, children: [DeckNode]) {
        self.name = name
        self.children = children
    }

    convenience init(name : String) {
        self.init(name: name, children: [DeckNode]())
    }

    func addChild(child : DeckNode) {
        self.children.append(child)
    }

    func removeChild(child : DeckNode) {
        self.children = self.children.filter( {$0 !== child})
    }
}
