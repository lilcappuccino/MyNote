//
//  NoteResponse.swift
//  Notes
//
//  Created by dewill on 04/08/2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct NoteResponse: Codable {
    let files: Files
   
    
    enum CodingKeys: String, CodingKey {
        case files
      
    }
}

// MARK: - Files
struct Files: Codable {
    let noteContent: NoteContent
    
    enum CodingKeys: String, CodingKey {
        case noteContent = "ios-course-notes-db"
    }
}

// MARK: - IosCourseNotesDB
struct NoteContent: Codable {
    let filename, type: String
    let content: String
    
}




    


