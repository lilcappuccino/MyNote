//
//  SaveNoteDBOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import CoreData

class SaveNoteDBOperation: BaseDBOperation {
    let TAG = "SaveNoteDBOperation"
    private let backgroundContext: NSManagedObjectContext
    
    let note: Note
    
    init(notebook: FileNotebook, note: Note, backgroundContext: NSManagedObjectContext) {
        self.note = note
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
       CustomLog.info(tag: TAG, message: Thread.current)
        if !note.title.isEmpty || !note.description.isEmpty
        {
            notebook.add(note)
            notebook.saveToFile()
            let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
            fetchRequest.predicate = NSPredicate(format: "uid = %@", self.note.uid)
            do {
                let result = try self.backgroundContext.fetch(fetchRequest)
                if let note = result.first {
                     prepareEntity(noteEnity: note)
                } else {
                      let newNote = NSEntityDescription.insertNewObject(forEntityName: "NoteEntity", into: self.backgroundContext) as! NoteEntity
                    prepareEntity(noteEnity: newNote)
                }
            } catch let error{
                CustomLog.error(tag: TAG, message: "Can't save to db \(error)")
            }
            
        }
        finish()
    }
    

    
    private func prepareEntity(noteEnity : NoteEntity){
        noteEnity.uid = self.note.uid
        noteEnity.title = self.note.title
        noteEnity.content = self.note.description
        noteEnity.selfDestructionDate = self.note.selfDestructionDate
        noteEnity.color = self.note.color.htmlRGBColor
        noteEnity.importance = Int16(self.note.importance.rawValue)
        self.backgroundContext.performAndWait {
            do {
                try self.backgroundContext.save()
                CustomLog.info(tag: TAG, message: "Success save \(noteEnity.uid) to DB")
            } catch {
                CustomLog.error(tag: TAG, message: error.localizedDescription)
            }
        }
    }
}
