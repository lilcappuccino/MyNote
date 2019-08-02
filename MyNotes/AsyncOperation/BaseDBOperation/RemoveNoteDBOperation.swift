//
//  RemoveNoteDBOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    let noteUid: String
    
    
    init(notebook: FileNotebook, noteUid: String) {
        self.noteUid = noteUid
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("init RemoveNoteDBOperation \(Thread.current)")
        if !noteUid.isEmpty {
            notebook.remove(with: noteUid)
        }
        finish()
  }
}
