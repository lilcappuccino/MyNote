//
//  RemoveNoteOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import CoreData


class RemoveNoteOperation: AsyncOperation {
    private let noteUid: String
    private let notebook: FileNotebook
    private let removeFromDb: RemoveNoteDBOperation
    private let removeFromBackend: RemoveNotesBackendOperation
    private let backgroundContext: NSManagedObjectContext
    
    private(set) var result: Bool? = false
    
    /// Remove from local, then update backend storge. If duaring savingt to backend  we will have error = retry
    init(noteUid: String,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.noteUid = noteUid
        self.notebook = notebook
        self.backgroundContext = backgroundContext
        print("init RemoveOperation \(Thread.current)")
        removeFromDb = RemoveNoteDBOperation(backgroundContext: backgroundContext, notebook: notebook, noteUid: noteUid)
        removeFromBackend = RemoveNotesBackendOperation(notebook: notebook, notesUid: noteUid)
        super.init()
        
        dbQueue.addOperation(removeFromDb)
        removeFromBackend.addDependency(removeFromDb)
        backendQueue.addOperation(removeFromBackend)
        self.addDependency(removeFromBackend)
        
    }
    
    override func main() {
        print("3-RemoveOperation")
        guard let backendResult = removeFromBackend.result else { result = false; return  }
        switch backendResult {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
