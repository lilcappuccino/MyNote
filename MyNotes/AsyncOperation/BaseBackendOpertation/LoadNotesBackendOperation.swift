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
    case success([Note]?)
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation
{
    private let TAG = "LoadNotesBackendOperation"
    private(set) var result: LoadNotesBackendResult?
    
    var notes: [Note]?
    
    override func main() {
        result = .failure(.unreachable)
        CustomLog.info(tag: TAG, message: Thread.current)
        if let noteFileId = NoteDefaults.gistId {
            getNoteList(by: noteFileId)
        } else { executedDidWithError(error: .unreachable)}
}
    
    
 private func getNoteList(by id : String)
    {
        let url = URL(string: "\(baseUrl)/gists/\(id)")
        guard let requestUrl = url else {
            executedDidWithError(error: NetworkError.unreachable)
            return }
        guard var request = NetworkUtils.getBaseRequest(url: requestUrl) else { executedDidWithError(error: .unreachable); return }
        request.httpMethod = "GET"
        executeTast(with: request)
    }



private func executedDidWithError(error : NetworkError) {
    CustomLog.error(tag: TAG, message: Thread.current)
    result = LoadNotesBackendResult.failure(error)
    self.finish()
}

//private func buildRequestBody() -> [String: Any]? {
//    guard let content = getContnent() else {
//        executedDidWithError(error: NetworkError.unreachable)
//        return nil
//    }
//    let requestBody = NoteRequest(files: ["ios-course-notes-db" : ["content": content]])
//    return requestBody.getDictionary()
//}


//private func getContnent() -> String? {
//    guard let requestNotes = notes else {
//        executedDidWithError(error: NetworkError.unreachable)
//        return nil
//
//    }
//    let jsonArray = requestNotes.map { $0.json}
//    let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray, options: [])
//    guard let jData = jsonData else {
//        executedDidWithError(error: NetworkError.unreachable)
//        return nil
//    }
//    let content = String(data: jData, encoding: String.Encoding.utf8)
//    return content
//}


private func executeTast(with request: URLRequest){
    let task = URLSession.shared.dataTask(with: request) { (data, response, error)  in
        
        if let error = error {
            self.result = .failure(.unreachable)
            print(error.localizedDescription)
            self.finish()
        }
        
//        if let response = response as? HTTPURLResponse {
//            switch response.statusCode {
//            case 200..<300:
////                self.result = .s
//                print("Success")
//            default:
//                print("Status: \(response.statusCode)")
//            }
//        }
        
        guard let responseData = data else {
            self.executedDidWithError(error: NetworkError.unreachable)
            return
        }
        if let parsedDate = try? JSONDecoder().decode(NoteResponse.self, from: responseData){
          self.convertStringToConent(from: parsedDate.files.noteContent.content)
        }

        self.finish()
    }
    task.resume()
    
}
    
    private func convertStringToConent(from string : String) {
        do {
            guard let data = string.data(using: .utf8) else { return }
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                notes = [Note]()
                jsonData.forEach{ dictionary in
                    if let note = Note.parse(json: dictionary){
                    notes?.append(note)
                    }
                }
                result = .success(notes)
                CustomLog.info(tag: TAG, message: "Loading success")
            }
        }catch {
            print(error.localizedDescription)
        }

    }
}
