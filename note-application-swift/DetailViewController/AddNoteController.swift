//
//  AddNoteController.swift
//  note-application-swift
//
//  Created by Cody on 2/13/23.
//

import UIKit
import RealmSwift
import Photos
import PhotosUI

class AddNoteController: UIViewController, PHPickerViewControllerDelegate {
    
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tvContent : UITextView!
    
    private var images = [UIImage]()
    private var imagesLocation = [Int]()
    private var timeRemind: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "checkmark"),
                style: .done,
                target: self,
                action: #selector(saveNote)),
            UIBarButtonItem(
                image: UIImage(systemName: "photo.on.rectangle"),
                style: .done,
                target: self,
                action: #selector(onSelectedImage))
        ]
        setup()
    }
    
    private func setup() {
        tfTitle.layer.borderWidth = 1
        tfTitle.layer.borderColor = UIColor.darkGray.cgColor
        tvContent.layer.borderWidth = 1
        tvContent.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    @objc func saveNote() {
        let realm = try! Realm()
        
        guard let title = tfTitle.text, let content = tvContent.text, !title.isEmpty else {
            return
        }
        
        print(tvContent.text!)
        let data = Note(id: UUID().uuidString, title: title, dateReminder: timeRemind, content: content as NSString)
        
        print("Images: ", data.images)
        print("Locations: ", data.imagesLocation)
        try! realm.write{
            realm.add(data)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func onSelectedImage() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    private func insertImage(image: UIImage, location: Int) {
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage, error == nil {
                    self.images.append(image)
                    self.imagesLocation.append(self.tvContent.selectedRange.location)
                    DispatchQueue.main.async {
                        let attachImage = self.images[self.images.count - 1]
                        let attachImageLocation = self.tvContent.selectedRange.location
                        
//                        Caculate new size
                        let newImageWidth = (self.tvContent.bounds.size.width)
                        let scale = newImageWidth/image.size.width
                        let newImageHight = image.size.height*scale
                        
                        let attachment = NSTextAttachment()
                        attachment.bounds = CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHight)
                        attachment.image = attachImage
                        
                        let attachString = NSAttributedString(attachment: attachment)
                        self.tvContent.textStorage.insert(
                            attachString,
                            at: self.tvContent.selectedRange.location)
                    }
                }
            }
        }
    }
}
