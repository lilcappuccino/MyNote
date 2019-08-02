//
//  BaseDBOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation

class BaseDBOperation: AsyncOperation {
    let notebook : FileNotebook
    
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
