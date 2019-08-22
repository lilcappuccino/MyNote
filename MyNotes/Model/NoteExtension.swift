//
//  NoteExtension.swift
//  MyNotes
//
//  Created by dewill on 19/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation
import UIKit

extension Note {
    var json : [String: Any]{
        var innerJson = [String : Any]()
        innerJson["title"] = self.title
        innerJson["uid"] = self.uid
        innerJson["content"] = self.description
        innerJson["self_destruction_date"] = self.selfDestructionDate?.timeIntervalSince1970
        if self.importance.rawValue != Note.Importance.low.rawValue { innerJson["importance"] = self.importance.rawValue }
        if self.color != UIColor.white { innerJson["color"] = self.color.htmlRGBColor }
        return innerJson
    }
    
    static func parse(json: [String: Any]) -> Note? {
        var title : String?
        var content : String?
        var uid : String?
        var color : UIColor?
        var date: Date?
        var note : Note?
        var importance = Note.Importance.low
        if let noteTitle = json["title"]  as?  String { title = noteTitle }
        if let noteUid = json["uid"]  as?  String { uid = noteUid }
        if let noteContent = json["content"] as? String {content = noteContent}
        if let noteColor = json["color"] as? String { color = UIColor(hexString: noteColor)
        }
        if let noteImportance = json["importance"] as? Int {
            importance = Note.Importance.init(rawValue: noteImportance) ?? Note.Importance.low
            
        }
    
    
        if let noteSelfDestructionDate = json["self_destruction_date"] as? Int { date = Date(timeIntervalSince1970: TimeInterval(noteSelfDestructionDate))}
        if let noteTitle = title, let noteContent = content, let noteUid = uid {
            note = Note(uid: noteUid, title: noteTitle, content: noteContent, color: color ?? UIColor.white,
                        selfDestructionDate: date, importance: importance )
        }
        
        return note
 }
}


extension UIColor {
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    // hue, saturation, brightness and alpha components from UIColor**
    var hsbComponents:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
            return (hue,saturation,brightness,alpha)
        }
        return (0,0,0,0)
    }
    var htmlRGBColor:String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    var htmlRGBaColor:String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
    }
    
    public convenience init?(hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    
    }
}
