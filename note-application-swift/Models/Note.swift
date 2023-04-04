//
//  Note.swift
//  note-application-swift
//
//  Created by Cody on 2/9/23.
//
import RealmSwift
import Foundation
class Note: Object {
    @objc dynamic var id: String!
    @objc dynamic var title: String!
    @objc public var dateReminder: Date!
    @objc dynamic var content: NSString!
    let images = List<String>()
    
//    convenience init(title: String!, dateCreate: Date!, dateReminder: Date!, content: String!) {
//        self.init()
//        self.title = title
//        self.dateCreate = dateCreate
//        self.dateReminder = dateReminder
//        self.content = content
//    }
    
    convenience init(id: String!, title: String!, dateReminder: Date!, content: NSString!) {
        self.init()
        self.id = id
        self.title = title
        self.dateReminder = dateReminder
        self.content = content
    }
    
    func addImageToNote(imageName: String) {
        self.images.append(imageName)
    }
    
    func saveNewImages(imageList: List<String>) {
        self.images.append(objectsIn: images)
    }
}
