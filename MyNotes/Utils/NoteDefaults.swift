//
//  NoteDefaults.swift
//  MyNotes
//
//  Created by dewill on 04/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation




fileprivate let keyTokenId = "TOKEN_ID"
fileprivate let keyGistId = "GIST_ID"

class NoteDefaults  {
    
  static  var gistId : String? {
        set{
            UserDefaults.standard.set(newValue, forKey: keyGistId)
        }
        get{
           return UserDefaults.standard.string(forKey: keyGistId)
        }
    }
    
    static var token : String? {
        set{
            UserDefaults.standard.set(newValue, forKey: keyTokenId)
        }
        get{
            return UserDefaults.standard.string(forKey: keyTokenId)
        }
    }
    
}


