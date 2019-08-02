//
//  RemoveNoteOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation


class RemoveNoteOperation: AsyncOperation {
    private let noteUid: String
    private let notebook: FileNotebook
    private let removeFromDb: RemoveNoteDBOperation
    private let removeFromBackend: RemoveNotesBackendOperation
    
    private(set) var result: Bool? = false
    
    init(noteUid: String,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.noteUid = noteUid
        self.notebook = notebook
        print("init RemoveOperation \(Thread.current)")
        removeFromDb = RemoveNoteDBOperation(notebook: notebook, noteUid: noteUid)
        removeFromBackend = RemoveNotesBackendOperation(notesUid: noteUid)
        super.init()
        

        removeFromDb.addDependency(removeFromBackend)
        backendQueue.addOperation(removeFromBackend)
        

        self.addDependency(removeFromDb)
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        print("RemoveNoteOperation \(Thread.current)")
        switch removeFromBackend.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
