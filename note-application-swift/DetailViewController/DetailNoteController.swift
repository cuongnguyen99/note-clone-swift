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
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var imageContainer: UIScrollView!
    @IBOutlet weak var tvTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageContainerHeight: NSLayoutConstraint!
    private var images = List<String>()
    private var newImages = List<String>()
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
        tvContent.text = note.content as String?
        
        if (note.images.isEmpty) {
            imageContainerHeight.constant = 0
            tvTopConstraint.constant = 0
        } else {
            for item in note.images {
                let noteImage = NoteImage(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                noteImage.configure(imagePath: item)
                noteImage.translatesAutoresizingMaskIntoConstraints = false
                imageStack.addArrangedSubview(noteImage)
//                self.imageContainerHeight.constant = 100
//                self.tvTopConstraint.constant = 10
            }
        }
        
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
                for item in newImages {
                    dataFilter.addImageToNote(imageName: item)
                }
            }
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onSelectedImage() {
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
                guard let fileName = result.itemProvider.suggestedName else {return}
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { (url, error) in
                    if let url = url {
                        let imageUrl = url.absoluteURL
                        print("URL: ", imageUrl)
                        DispatchQueue.main.async { [self] in
                            images.append(fileName)
                            newImages.append(fileName)
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
