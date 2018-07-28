//
//  NotesViewController.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/26/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import RealmSwift
import TOPasscodeViewController

let realm = try! Realm()

class NotesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var displayTypeButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    
    let ratio:CGFloat = 1
    let gridLayout = GridLayout()
    let listLayout = ListLayout()
    
    var dataSource: [Note] = []
    var displayType: DisplayType = .list
    var currentSelectedNote: Note?
    
    @IBOutlet weak var heightAddButtonConstraint: NSLayoutConstraint! {
        didSet {
            heightAddButtonConstraint.constant = 42*ratio
        }
    }
    override func viewDidLoad() {
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
        getNotes()
        setViews()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = Color.barTint
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
        dataSource = Array(notes).reversed()
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
        currentSelectedNote = nil
        performSegue(withIdentifier: "toDetailNoteVCSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailNoteVCSegue" {
            let vc = segue.destination as! DetailNoteViewController
            vc.delegate = self
            vc.note = currentSelectedNote
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteListCell", for: indexPath) as! NoteListCell
            cell.data = dataSource[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //check note isLocked
            let note = dataSource[indexPath.row]
            currentSelectedNote = note
            if note.isLocked {
                //show passcode view
                handleShowPasscodeVC()
            } else {
                performSegue(withIdentifier: "toDetailNoteVCSegue", sender: note)
            }
    }

    func handleShowPasscodeVC() {
        let passcodeVC = TOPasscodeViewController(style: .opaqueLight, passcodeType: .fourDigits)
        passcodeVC.delegate = self
        present(passcodeVC, animated: true, completion: nil)
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

extension NotesViewController: TOPasscodeViewControllerDelegate {
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        if code == PassCodeManager.passCode {
            performSegue(withIdentifier: "toDetailNoteVCSegue", sender: currentSelectedNote)
            return true
        } else {
            return false
        }
    }
    
    func didTapCancel(in passcodeViewController: TOPasscodeViewController) {
        dismiss(animated: true, completion: nil)
    }
}
