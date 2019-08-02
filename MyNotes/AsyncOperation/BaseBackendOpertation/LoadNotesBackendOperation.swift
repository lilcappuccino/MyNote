//
//  LoadNotesBackendOperation.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation


enum LoadNotesBackendResult
{
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation
{
    private(set) var result: LoadNotesBackendResult?
    
    var notes: [Note]?
    
    override func main()
    {
          print("LoadNotesBackendOperation \(Thread.current)")
        result = .failure(.unreachable)
        finish()
    }
}
