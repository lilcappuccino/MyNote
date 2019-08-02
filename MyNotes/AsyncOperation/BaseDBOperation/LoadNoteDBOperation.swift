//
//  LoadNoteDBOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation

class LoadNoteDBOperation: BaseDBOperation {
    private(set)  var  noteList: [Note] = []
    
    
    override func main() {
          print("LoadNoteDBOperation \(Thread.current)")
        notebook.loadFromFile()
        noteList = notebook.notes
        finish()
    }
}
