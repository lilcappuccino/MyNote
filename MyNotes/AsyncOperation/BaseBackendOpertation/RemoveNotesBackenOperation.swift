//
//  RemoveNotesBackenOperation.swift
//  MyNotes
//
//  Created by dewill on 02/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation




class RemoveNotesBackendOperation: BaseBackendOperation {
    var result: NotesBackendResult?
    
    init(notesUid: String) {
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        print("RemoveBackEndOperation \(Thread.current)  - \(result)")
        finish()
    }
}
