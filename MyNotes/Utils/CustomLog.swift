//
//  CustomLog.swift
//  MyNotes
//
//  Created by dewill on 05/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import SwiftyBeaver

// I use for logging SwiftyBeaver.
// use custrom log for install and unistall SwiftyBeaver  from all project
class CustomLog{
    
    static func error(tag: String = "", message: Any) {
        if !tag.isEmpty {
            SwiftyBeaver.error("[\(tag)] : \(message)")
        } else {
            SwiftyBeaver.error("\(message)")
        }
    }
    
    static func info(tag: String = "", message: Any) {
        if !tag.isEmpty {
            SwiftyBeaver.info("[\(tag)] : \(message)")
        } else {
            SwiftyBeaver.info("\(message)")
        }
    }
    
    static func waring(tag: String = "", message: Any) {
        if !tag.isEmpty {
            SwiftyBeaver.warning("[\(tag)] : \(message)")
        } else {
            SwiftyBeaver.warning("\(message)")
        }
    }
    
}
