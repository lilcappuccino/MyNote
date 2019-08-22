//
//  Note.swift
//  MyNotes
//
//  Created by dewill on 17/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import UIKit

struct Note {
    let uid : String
    let title : String
    let description : String
    let color : UIColor
    let selfDestructionDate : Date?
    let importance : Importance
    
    enum Importance : Int {
        case hight = 2
        case medium = 1
        case low = 0
    }
    
    init(uid: String?, title : String, content : String, color : UIColor = UIColor.white, selfDestructionDate : Date?, importance : Importance = Importance.low) {
        self.uid = uid ?? UUID().uuidString
        self.title = title
        self.description = content
        self.color = color
        self.selfDestructionDate = selfDestructionDate
        self.importance = importance
    }
}

