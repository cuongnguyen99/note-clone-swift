//
//  NoteImage.swift
//  note-application-swift
//
//  Created by Cody on 4/3/23.
//

import UIKit

class NoteImage: UIView {
    static let identifier: String = Identifier.NoteImage.rawValue;
    @IBOutlet var noteImage: UIImageView!
    
    public func configure(imagePath: String){
        var documentURL: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let url = documentURL.appendingPathComponent(imagePath)
        do {
            let imageData = try Data(contentsOf: url)
            self.noteImage.image = UIImage(data: imageData)
        } catch {
            print("Error loading image");
        }
        
//        let url = URL(filePath: imagePath)
//        let image = UIImage(contentsOfFile: url.absoluteString)
//        self.noteImage.image = image
//        self.noteImage.image = UIImage(contentsOfFile: imagePath as String)
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed(Identifier.NoteImage.rawValue, owner: self, options: nil)?.first as? UIView
        viewFromXib?.frame = bounds
        addSubview(viewFromXib!)
    }
}
