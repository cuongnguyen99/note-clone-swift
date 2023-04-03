//
//  DetailNoteController.swift
//  note-application-swift
//
//  Created by Cody on 2/9/23.
//

import UIKit
import RealmSwift
import Photos
import PhotosUI

class DetailNoteController: UIViewController, PHPickerViewControllerDelegate {
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvContent: UITextView!
    
    private var images = [UIImage]()
    
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        tfTitle.layer.borderWidth = 1
        tfTitle.layer.borderColor = UIColor.darkGray.cgColor
        tfTitle.text = note.title
        tvContent.layer.borderWidth = 1
        tvContent.layer.borderColor = UIColor.darkGray.cgColor
//        tvContent.text = note.content
//        var attributedString: NSMutableAttributedString!
//        attributedString = NSMutableAttributedString(attributedString: self.tvContent.attributedText)
//        tvContent.attributedText = t
//        tvContent.attributedText = NSAttributedString(string: note.content)
//        tvContent.textStorage.insert(NSAttributedString(string: note.content), at: 0)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "checkmark"),
                style: .done,
                target: self,
                action: #selector(updateNote)),
            UIBarButtonItem(
                image: UIImage(systemName: "photo.on.rectangle"),
                style: .done,
                target: self,
                action: #selector(onSelectedImage))
        ]
    }
    
    @objc func updateNote() {
        let realm = try! Realm()
        guard let titleChanged = tfTitle.text, !titleChanged.isEmpty else {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        let dataFilter = realm.objects(Note.self).filter("id = %@", note.id!).toArray(ofType: Note.self).first
        if let dataFilter = dataFilter {
            try! realm.write{
                dataFilter.title = tfTitle.text
                dataFilter.content = tvContent.attributedText.string as NSString
            }
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func onSelectedImage() {
        print("Select image")
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage, error == nil {
                    self.images.append(image)
                    DispatchQueue.main.async {
                        let attachImage = self.images[self.images.count - 1]
                        
                        //Caculate new size
                        let newImageWidth = (self.tvContent.bounds.size.width)
                        let scale = newImageWidth/image.size.width
                        let newImageHight = image.size.height*scale
                        
                        let attachment = NSTextAttachment()
                        attachment.bounds = CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHight)
                        attachment.image = attachImage
                        
                        var attributedString: NSMutableAttributedString!
                        attributedString = NSMutableAttributedString(attributedString: self.tvContent.attributedText)
                        
                        let attachString = NSAttributedString(attachment: attachment)
//                        self.tvContent.textStorage.insert(
//                            attachString,
//                            at: self.tvContent.selectedRange.location)
                        attributedString.append(attachString)
                        self.tvContent.attributedText = attributedString
                    }
                }
            }
        }
    }
}
