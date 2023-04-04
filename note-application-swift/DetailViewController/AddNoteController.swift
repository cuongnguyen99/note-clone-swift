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
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var imageContainer: UIScrollView!
    @IBOutlet weak var imageContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var tvTopConstraint: NSLayoutConstraint!
    
    private var images = List<String>()
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
        imageContainerHeight.constant = 0
        tvTopConstraint.constant = 0
    }
    
    @objc func saveNote() {
        let realm = try! Realm()
        
        guard let title = tfTitle.text, let content = tvContent.text, !title.isEmpty else {
            return
        }
        
        var data = Note(id: UUID().uuidString, title: title, dateReminder: timeRemind, content: content as NSString)
        
        if (!images.isEmpty) {
            for item in images {
                data.addImageToNote(imageName: item)
            }
        }
        
        print("Images: ", data.images)
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
                guard let fileName = result.itemProvider.suggestedName else {return}
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { (url, error) in
                    if let url = url {
                        let imageUrl = url.absoluteURL
                        print("URL: ", imageUrl)
                        DispatchQueue.main.async { [self] in
                            images.append(fileName)
                            let noteImage = NoteImage(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                            noteImage.configure(imagePath: fileName)
                            noteImage.translatesAutoresizingMaskIntoConstraints = false
                            imageStack.addArrangedSubview(noteImage)
                            self.imageContainerHeight.constant = 100
                            self.tvTopConstraint.constant = 10
                        }
                    }
                }
            }
        }
    }
}
