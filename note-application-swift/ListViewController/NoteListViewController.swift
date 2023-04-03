//
//  ViewController.swift
//  note-application-swift
//
//  Created by Cody on 2/7/23.
//
import RealmSwift
import UIKit

class NoteListViewController: UITableViewController {
    @IBOutlet var addNoteButton: UIBarButtonItem!
    
//    let realm = try! Realm()
//    var noteList: [Results<Note>] = [Results<Note>]()
    var noteList: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        getNoteList()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register( NoteListCell.nib(), forCellReuseIdentifier: NoteListCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNoteList()
        tableView.reloadData()
    }
    
    private func onDeleteButtonPress(id: String) {
        let realm = try! Realm()
        let dataFilter = realm.objects(Note.self).filter("id = %@", id)
        try! realm.write {
            realm.delete(dataFilter)
        }
    }
    
    private func getNoteList() {
        let realm = try! Realm()
        noteList = realm.objects(Note.self).toArray(ofType: Note.self)
    }
    
    @IBAction func onAddButtonPress() {
        let vc = storyboard?.instantiateViewController(identifier: Identifier.AddNoteController.rawValue) as! AddNoteController
        vc.title = "New Note"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = NSLocalizedString("Note", comment: "Note view controller title")
        /*navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: nil
        )
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .yellow
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "Note List"*/
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if let vc = storyboard?.instantiateViewController(identifier: Identifier.DetailNoteController.rawValue) as? DetailNoteController{
//            vc.noteTitle = Note.notesSample[indexPath.row].title
//            vc.noteContent = Note.notesSample[indexPath.row].content
            vc.note = Note.notesSample[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        let vc = storyboard?.instantiateViewController(identifier: Identifier.DetailNoteController.rawValue) as! DetailNoteController
        vc.note = noteList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListCell", for: indexPath) as! NoteListCell
        let item = noteList[indexPath.row]
        cell.configure(title: item.title, content: item.content as String)
        /*if (indexPath.row == 0) {
            NSLayoutConstraint(item: cell, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        }*/
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        if editingStyle == .delete {
            let item = noteList[indexPath.row]
            try! realm.write({
                realm.delete(item)
            })
        }
    
        noteList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var arr = [T]()
        for i in 0..<count {
            if let result = self[i] as? T {
                arr.append(result)
            }
        }
        return arr
    }
}


