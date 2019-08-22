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
     private var notebook : FileNotebook
    
    init(notebook: FileNotebook, notesUid: String) {
        print("2- INIT: RemoveNotesBackendOperation")
        self.notebook = notebook
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        if let gistId = NoteDefaults.gistId {
            updateNoteFile(by: gistId)
        } else {
            executedDidWithError(error: .unreachable)
        }
        print("2- RemoveNotesBackendOperation")
        
    }
    
    
    private func executedDidWithError(error : NetworkError) {
        print("error")
        result = NotesBackendResult.failure(error)
        self.finish()
    }
    
    private func buildRequestBody() -> [String: Any]? {
        guard let content = getContnent() else {
            executedDidWithError(error: NetworkError.unreachable)
            return nil
        }
        let requestBody = NoteRequest(files: ["ios-course-notes-db" : ["content": content]])
        return requestBody.getDictionary()
    }
    
    
    private func getContnent() -> String? {
        let jsonArray = notebook.notes.map { $0.json}
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray, options: [])
        guard let jData = jsonData else {
            executedDidWithError(error: NetworkError.unreachable)
            return nil
        }
        let content = String(data: jData, encoding: String.Encoding.utf8)
        return content
    }
    

    private func updateNoteFile(by id: String){
        let url = URL(string: "\(baseUrl)/gists/\(id)")
        guard let requestUrl = url else {
            executedDidWithError(error: NetworkError.unreachable)
            return }
        guard var request = NetworkUtils.getBaseRequest(url: requestUrl) else { executedDidWithError(error: .unreachable); return }
        request.httpMethod = "PATCH"
        do {
            guard let file = buildRequestBody() else {
                executedDidWithError(error: NetworkError.unreachable)
                return }
            request.httpBody = try JSONSerialization.data(withJSONObject: file, options: [])
        } catch let error {
            executedDidWithError(error: NetworkError.unreachable)
            print(error.localizedDescription)
        }
        executeTast(with: request)
    }
    
    private func executeTast(with request: URLRequest){
        let task = URLSession.shared.dataTask(with: request) { (data, response, error)  in
           
            if let error = error {
                self.result = .failure(.unreachable)
                print(error.localizedDescription)
                self.finish()
            }
           
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    self.result = .success
                    print("Success")
                default:
                    print("Status: \(response.statusCode)")
                }
            }
           
            guard let responseData = data else {
                self.executedDidWithError(error: NetworkError.unreachable)
                return
            }
            let parsedDate = try? JSONDecoder().decode(CreateNoteResponse.self, from: responseData)
            NoteDefaults.gistId  = parsedDate?.id
            self.finish()
        }
        task.resume()
        
    }
    
}
