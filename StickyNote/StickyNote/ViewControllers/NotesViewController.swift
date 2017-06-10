//
//  NotesViewController.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/26/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

class NotesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNoteButton: UIButton!

    var dataSource: [Note] = []
    var displayType: DisplayType = .details
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
        setViews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        getNotes()
    }

    @IBOutlet weak var widthDoneConstraint: NSLayoutConstraint!
    func setViews() {
        let radius = addNoteButton.frame.height/2
        addNoteButton.boderAndCorner(radius: radius)
        initCells()
    }
    
    func initCells() {
        tableView.register(UINib(nibName: String(describing: NoteCell.self), bundle: nil), forCellReuseIdentifier: "noteCell")
        tableView.register(UINib(nibName: String(describing: NoteListCell.self), bundle: nil), forCellReuseIdentifier: "noteListCell")
    }
    
    func getNotes() {
        let notes = realm.objects(Note.self)
        dataSource = Array(notes)
    }
    func deleteNote(note: Note) {
        if let index = dataSource.index(where: { item -> Bool in item.id == note.id }) {
            dataSource.remove(at: index)
            tableView.reloadData()
            try! realm.write {
                realm.delete(note)
            }
        }
    }
    
    func editNote(note: Note) {
        if let index = dataSource.index(where: { item -> Bool in item.id == note.id }) {
            dataSource[index] = note
            tableView.reloadData()
        }
    }
    
    func addNewNote(note: Note) {
        if !note.title.isEmpty || !note.content.isEmpty {
            dataSource.insert(note, at: 0)
            tableView.reloadData()
            try! realm.write {
                realm.add(note)
            }
        }
    }
    
    @IBAction func onAddNote(_ sender: Any) {
        performSegue(withIdentifier: "toDetailNoteVCSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailNoteVCSegue" {
            let vc = segue.destination as! DetailNoteViewController
            vc.delegate = self
            if let slectedIndex = tableView.indexPathForSelectedRow?.row {
                vc.note = dataSource[slectedIndex]
            }
        }
    }
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch displayType {
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteCell
            cell.data = dataSource[indexPath.row]
            return cell
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteListCell") as! NoteListCell
            cell.data = dataSource[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch displayType {
        case .details:
            return 88
        case .list:
            return 52
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailNoteVCSegue", sender: self)
    }
}

extension NotesViewController: DetailNoteViewControllerDelegate {
    func editNote(note: Note, state: NoteState) {
        switch state {
        case .new:
            addNewNote(note: note)
            break
        case .edit:
            editNote(note: note)
            break
        }
    }
    
    func deleteNotr(note: Note) {
       deleteNote(note: note)
    }
}
