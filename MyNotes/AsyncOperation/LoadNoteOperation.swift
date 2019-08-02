//
//  LoadNoteOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
class LoadNoteOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadFromDb: LoadNoteDBOperation
    private let loadFromBackend: LoadNotesBackendOperation
    private(set) var notes : [Note]?
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.notebook = notebook
        
        loadFromDb = LoadNoteDBOperation(notebook: notebook)
        loadFromBackend = LoadNotesBackendOperation()
        
        super.init()
          print("init LoadNoteOperation \(Thread.current)")
        
        backendQueue.addOperation(loadFromBackend)
        loadFromDb.addDependency(loadFromBackend)
        dbQueue.addOperation(loadFromDb)
        addDependency(loadFromDb)
    }
    
    
    //MARK -> Loading from backend ; if result == failure , then from bd
    override func main() {
          print(" LoadNoteOperation \(Thread.current)")
        switch loadFromBackend.result! {
        case .success: getNoteFromBackend()
        case .failure:
            result = false;  notes = loadFromDb.noteList
        }
        finish()
    }
    
    private func getNoteFromBackend(){
        result = true
        if let notesFromBackend = loadFromBackend.notes {
            notes = notesFromBackend
            notebook.replace(to: notesFromBackend)
        }
    }
}
