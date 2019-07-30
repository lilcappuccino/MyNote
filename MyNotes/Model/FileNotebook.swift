//
//  FileNotebook.swift
//  MyNotes
//
//  Created by dewill on 19/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation

class FileNotebook{
    
    private (set) var notes = [Note]()
    
    public func add(_ note: Note){
        notes.append(note)
    }
    
    public func remove(with uid: String){
        notes = notes.filter {$0.uid != uid }
    }
    
    public func saveToFile() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
            do {
                let jsonArray = notes.map { $0.json }
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let pathSave = path.appendingPathComponent("notebook.json")
                FileManager.default.createFile(atPath: pathSave.path, contents: data, attributes: nil)
            } catch let error {
                print("Can't save notes to file: \(error.localizedDescription)")
            }
        
    }
    
    public func loadFromFile(){
        self.notes.removeAll()
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
            do {
                let pathFile = path.appendingPathComponent("notebook.json")
                if let data = FileManager.default.contents(atPath: pathFile.path),
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    
                    jsonData.forEach{ if let note = Note.parse(json: $0){
                        notes.append(note)
                        }
                    }
                } else {
                    print("Can't load notes from file.")
                }
            } catch let error {
                print("Can't load notes from file: \(error.localizedDescription)")
            }
        
    }
    
}
