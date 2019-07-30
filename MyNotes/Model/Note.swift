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
    let content : String
    let color : UIColor
    let selfDestructionDate : Date?
    let importance : Importance
    
    enum Importance : String {
        case hight = "hight"
        case medium = "medium"
        case low = "low"
    }
    
    init(uid: String =  UUID().uuidString, title : String, content : String, color : UIColor = UIColor.white, selfDestructionDate : Date?, importance : Importance = Importance.low) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.selfDestructionDate = selfDestructionDate
        self.importance = importance
    }
}

