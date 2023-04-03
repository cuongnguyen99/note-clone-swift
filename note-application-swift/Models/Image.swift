//
//  Image.swift
//  note-application-swift
//
//  Created by Cody on 2/20/23.
//
import Foundation
import UIKit
import RealmSwift
class Image: Object {
    @objc dynamic var image: NSData?
    @objc dynamic var imageLocation: Int = 0
    
    convenience init(image: NSData!, imageLocation: Int!) {
        self.init()
        self.image = image
        self.imageLocation = imageLocation
    }
}
