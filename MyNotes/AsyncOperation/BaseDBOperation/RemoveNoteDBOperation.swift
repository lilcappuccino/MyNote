//
//  RemoveNoteDBOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import CoreData

class RemoveNoteDBOperation: BaseDBOperation {
    let noteUid: String
    let backgroundContext: NSManagedObjectContext
    let TAG = "RemoveNoteDBOperation"
    
    
    init(backgroundContext: NSManagedObjectContext, notebook: FileNotebook, noteUid: String) {
        self.noteUid = noteUid
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("1 RemoveNoteDBOperation \(Thread.current)")
        if !noteUid.isEmpty {
            notebook.remove(with: noteUid)
            
            // Remove from db
            let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
            fetchRequest.predicate = NSPredicate(format: "uid = %@", self.noteUid)
            do {
                let result = try self.backgroundContext.fetch(fetchRequest)
                let deletingNote = (result as [NoteEntity]).first
                guard let note = deletingNote else {
                    CustomLog.error(tag: TAG, message: "Not found in store ID:\(self.noteUid)")
                    finish(); return
                      }
                
                CustomLog.info(tag: TAG, message: "Found in store \(note.uid ?? "")")
                    self.backgroundContext.delete(note)
                    self.backgroundContext.performAndWait {
                        do {
                            try self.backgroundContext.save()
                        CustomLog.info(tag: TAG, message: "Success remove  \(note.uid ?? "")")
                  } catch { print(error) }
                    }
                
            } catch {
                CustomLog.error(tag: TAG, message: "Error find in store \(error)")
                
            }
        }
        finish()
    }
}
