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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var displayTypeButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    let gridLayout = GridLayout()
    let listLayout = ListLayout()
    var dataSource: [Note] = []
    var displayType: DisplayType = .list
    
    override func viewDidLoad() {
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
        getNotes()
        setViews()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = Color.yellow
        if dataSource.isEmpty {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }
    
    func setViews() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let radius = addNoteButton.frame.height/2
        addNoteButton.boderAndCorner(radius: radius)
        collectionView.collectionViewLayout.invalidateLayout()
        setDisplayType()
        initCells()
    }
    
    func setDisplayType () {
        switch displayType {
        case .grid:
            UIView.animate(withDuration: 0.5){
                self.displayTypeButton.setImage(UIImage(named: "ic_list"), for: .normal)
                self.collectionView.collectionViewLayout = self.gridLayout
            }
            break
        case .list:
            UIView.animate(withDuration: 0.5){
                self.displayTypeButton.setImage(UIImage(named: "ic_grid"), for: .normal)
                self.collectionView.collectionViewLayout = self.listLayout
            }
            break
        }
        collectionView.reloadData()
    }
    
    func initCells() {
        collectionView.register(UINib(nibName: String(describing: NoteCell.self), bundle: nil), forCellWithReuseIdentifier: "noteCell")
        collectionView.register(UINib(nibName: String(describing: NoteListCell.self), bundle: nil), forCellWithReuseIdentifier: "noteListCell")
        collectionView.register(UINib(nibName: String(describing: NoteGridCell.self), bundle: nil), forCellWithReuseIdentifier: "noteGridCell")
    }
    
    func getNotes() {
        let notes = realm.objects(Note.self)
        dataSource = Array(notes)
    }
    func deleteNote(note: Note) {
        if let index = dataSource.index(where: { item -> Bool in item.id == note.id }) {
            dataSource.remove(at: index)
            collectionView.reloadData()
            try! realm.write {
                realm.delete(note)
            }
        }
    }
    
    func editNote(note: Note) {
        if let index = dataSource.index(where: { item -> Bool in item.id == note.id }) {
            dataSource[index] = note
            collectionView.reloadData()
        }
    }
    
    func addNewNote(note: Note) {
        if !note.title.isEmpty || !note.content.isEmpty {
            dataSource.insert(note, at: 0)
            collectionView.reloadData()
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
            switch sender {
            case is NoteGridCell:
                if let slectedIndex = collectionView.indexPath(for: (sender as? NoteGridCell)!) {
                    vc.note = dataSource[slectedIndex.row]
                }
                break
            case is NoteCell:
                if let selectIndex = collectionView.indexPath(for: (sender as? NoteCell)!){
                    vc.note = dataSource[selectIndex.row]
                }
                break
            case is NoteListCell:
                if let selectIndex = collectionView.indexPath(for: (sender as? NoteListCell)!){
                    vc.note = dataSource[selectIndex.row]
                }
                break
            default:
                break
            }
        }
    }
    
    @IBAction func onSelectTypeDisplay(_ sender: Any) {
        if displayType == DisplayType.grid {
            displayType = DisplayType.list
        } else {
            displayType = DisplayType.grid
        }
        setDisplayType()
    }
}

extension NotesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch displayType {
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteGridCell", for: indexPath) as! NoteGridCell
            cell.data = dataSource[indexPath.row]
            return cell
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
            cell.data = dataSource[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            performSegue(withIdentifier: "toDetailNoteVCSegue", sender: cell)
        }
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
