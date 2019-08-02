//
//  SaveNoteDBOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    
    let note: Note
    
    init(notebook: FileNotebook, note: Note) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("SaveDBOperation \(Thread.current)")
        if !note.title.isEmpty || !note.content.isEmpty
        {
            notebook.add(note)
            notebook.saveToFile()
        }
        finish()
    }
}
