//
//  LoadNoteDBOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LoadNoteDBOperation: BaseDBOperation {
    private(set)  var  noteList: [Note] = []
    private let backgroundContext: NSManagedObjectContext
    let TAG = "LoadNoteDBOperation"
    
    init(notebook: FileNotebook, backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        CustomLog.info(tag: TAG, message: Thread.current)
        let request = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        do{
            let result = try self.backgroundContext.fetch(request) as [NoteEntity]
            CustomLog.waring(tag: TAG, message: "notesEntity count from bd \(result.count)")
            result.map{
                let color = UIColor(hexString: $0.color!) ?? UIColor.white
                let importance: Int = Int($0.importance)
                let note = Note(uid: $0.uid, title: $0.title!, content: $0.content!, color: color, selfDestructionDate: $0.selfDestructionDate, importance: Note.Importance(rawValue: importance)!)
                noteList.append(note)
                
            }
            CustomLog.waring(tag: TAG, message: "notes count from bd \(noteList.count)")
        } catch {
            CustomLog.error(tag: TAG, message: error.localizedDescription)
        }
        finish()
    }
}
