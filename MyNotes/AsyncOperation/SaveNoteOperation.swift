//
//  SaveNoteOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import CoreData


class SaveNoteOperation: AsyncOperation {
    let TAG = "SaveNoteOperation"
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private let saveToBackend: SaveNotesBackendOperation
    private let backgroundContext: NSManagedObjectContext
    
    private(set) var result: Bool? = false
    
    
    /// Save to local, then to backend storge. If duaring savingt to backend  we will have error = retry
    init(note: Note,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        self.backgroundContext = backgroundContext
        saveToDb = SaveNoteDBOperation(notebook: notebook, note: note, backgroundContext: backgroundContext)
        saveToBackend = SaveNotesBackendOperation(notebook: notebook)
        
        super.init()
        
        dbQueue.addOperation(saveToDb)
        saveToBackend.addDependency(saveToDb)
        backendQueue.addOperation(saveToBackend)
        self.addDependency(saveToBackend)
    }
    
    override func main() {
        CustomLog.info(tag: TAG, message: Thread.current)
        guard let backendResult = saveToBackend.result else { result = false; return  }
        switch backendResult {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
