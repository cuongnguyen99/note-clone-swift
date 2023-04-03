//
//  NoteListCell.swift
//  note-application-swift
//
//  Created by Cody on 2/9/23.
//

import UIKit

class NoteListCell: UITableViewCell {
    static let identifier: String = Identifier.NoteListCell.rawValue
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(title: String, content: String) {
        self.title.text = title
        self.content.text = content
    }
    
    static func nib() -> UINib{
        return UINib(nibName: Identifier.NoteListCell.rawValue, bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
