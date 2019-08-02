//
//  SaveNoteOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation


class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private let saveToBackend: SaveNotesBackendOperation
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
         print("init SaveOperation \(Thread.current)")
        saveToDb = SaveNoteDBOperation(notebook: notebook, note: note)
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        
        super.init()
        
        saveToDb.addDependency(saveToBackend)
        backendQueue.addOperation(saveToBackend)

        
        self.addDependency(saveToDb)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
        switch saveToBackend.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
