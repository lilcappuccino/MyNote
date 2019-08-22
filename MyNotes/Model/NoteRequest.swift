//
//  NoteRequest.swift
//  MyNotes
//
//  Created by dewill on 04/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation


struct NoteRequest: Decodable {
    let isPublic: Bool
    let descripton : String
    let files: [String : [String: String]]
    
    
  public  func getDictionary() -> [String: Any] {
        let jsonObject: [String: Any] = [
            "description" : descripton,
            "public" : isPublic,
            "files" : files
        ]
        return jsonObject
    }
    
    init(files: [String : [String: String]]) {
        self.isPublic = false
        self.descripton = requestDescription
        self.files = files
    }
}

private let requestDescription = "Created this gist for storing my notes"
