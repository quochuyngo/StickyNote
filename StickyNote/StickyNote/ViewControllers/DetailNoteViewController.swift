//
//  DetailNoteViewController.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/26/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailNoteViewControllerDelegate {
    func editNote(note: Note, state: NoteState)
    func deleteNote(note:Note)
}
class DetailNoteViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryColorButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeCreatedLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var note:Note!
    var delegate: DetailNoteViewControllerDelegate?
    var noteState: NoteState!
    let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        NotificationCenter.default.addObserver(self, selector: #selector(DetailNoteViewController.keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailNoteViewController.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setEditorStates(isEditing: false)
        //editTextView.contentSize.height = size.height + 40
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    func setViews() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 18
        let attributes = [NSParagraphStyleAttributeName: style]
        editTextView.attributedText = NSAttributedString(string: editTextView.text, attributes: attributes)
        editTextView.delegate = self
        titleTextField.delegate = self
        categoryColorButton.boderAndCorner(width: 1.2, color: UIColor.white, radius: 2)
        if let note = note {
            noteState = .edit
            let color = Color.getColorByCategory(category: (note.category?.color)!, isBackground: false)
            navigationController?.navigationBar.barTintColor = color
            categoryColorButton.backgroundColor = color
            let colorBG =  Color.getColorByCategory(category: (note.category?.color)!)
            editTextView.backgroundColor = colorBG
            timeView.backgroundColor = colorBG
        }
        else {
            noteState = .new
            note = Note()
            navigationController?.navigationBar.barTintColor = Color.yellow
            categoryColorButton.backgroundColor = Color.yellow
        }
        editTextView.text = note.content
        titleTextField.text = note.title
        timeCreatedLabel.text = note.formatFullDateTime()
    }
    
    func setData() {
      
        
    }
    
    func setColor(color: CategoryColor) {
        switch color {
        case .black:
            editTextView.backgroundColor = Color.blackBG
            timeView.backgroundColor = Color.blackBG
            navigationController?.navigationBar.barTintColor = UIColor.black
            categoryColorButton.backgroundColor = UIColor.black
            break
        case .blue:
            editTextView.backgroundColor = Color.blueBG
            timeView.backgroundColor = Color.blueBG
            navigationController?.navigationBar.barTintColor = Color.blue
            categoryColorButton.backgroundColor = Color.blue
            break
        case .brown:
            editTextView.backgroundColor = Color.brownBG
            timeView.backgroundColor = Color.brownBG
            navigationController?.navigationBar.barTintColor = UIColor.brown
            categoryColorButton.backgroundColor = UIColor.brown
            break
        case .green:
            editTextView.backgroundColor = Color.greenBG
            timeView.backgroundColor = Color.greenBG
            navigationController?.navigationBar.barTintColor = UIColor.green
            categoryColorButton.backgroundColor = UIColor.green
            break
        case .orange:
            editTextView.backgroundColor = Color.orangeBG
            timeView.backgroundColor = Color.orangeBG
            navigationController?.navigationBar.barTintColor = UIColor.orange
            categoryColorButton.backgroundColor = UIColor.orange
            break
        case .purple:
            editTextView.backgroundColor = Color.purpleBG
            timeView.backgroundColor = Color.purpleBG
            navigationController?.navigationBar.barTintColor = UIColor.purple
            categoryColorButton.backgroundColor = UIColor.purple
            break
        case .red:
            editTextView.backgroundColor = Color.redBG
            timeView.backgroundColor = Color.redBG
            navigationController?.navigationBar.barTintColor = UIColor.red
            categoryColorButton.backgroundColor = UIColor.red
            break
        case .white:
            editTextView.backgroundColor = UIColor.white
            timeView.backgroundColor = UIColor.white
            navigationController?.navigationBar.barTintColor = UIColor.gray
            categoryColorButton.backgroundColor = UIColor.white
            break
        case .yellow:
            editTextView.backgroundColor = Color.yellowBG
            timeView.backgroundColor = Color.yellowBG
            navigationController?.navigationBar.barTintColor = Color.yellow
            categoryColorButton.backgroundColor = Color.yellow
        }
    }
    
    func setEditorStates(isEditing: Bool) {
        if isEditing {
            UIView.animate(withDuration: 3, delay: 0.5, options: .curveEaseInOut, animations:  {
                self.doneButton.isHidden = false
                self.categoryColorButton.isHidden = true
                self.optionButton.isHidden = true
            }, completion: nil)
        } else {
             UIView.animate(withDuration: 5, delay: 0.6, options: .curveEaseInOut, animations:  {
                self.doneButton.isHidden = true
                self.categoryColorButton.isHidden = false
                self.optionButton.isHidden = false
             }, completion: nil)
        }
    }
    func configRx() {
        editTextView.rx.text.orEmpty.asObservable().subscribe(onNext: { text in
            if !text.isEmpty {
                self.categoryColorButton.isHidden = true
            }
        }).addDisposableTo(DisposeBag())
    }
    
    func keyBoardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
            setEditorStates(isEditing: true)
            //editTextView.contentSize.height = size.height + 100
        }
    }
    
    func keyBoardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        setEditorStates(isEditing: false)
        //editTextView.contentSize.height = size.height + 100
    }
    
    @IBAction func onOptionTap(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Lock", style: .default, handler: {
            UIAlertAction in
            self.performSegue(withIdentifier: "PasscodeVC", sender: self)
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            UIAlertAction in
            let alert = UIAlertController(title: "Delete Confirm!", message: "Are your sure you want to delete this note?", preferredStyle: .alert)
            
            alert.addAction(UIKit.UIAlertAction(title: "Delete", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
                self.delegate?.deleteNote(note: self.note!)
                _ = self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title:"Cancel", style:.cancel))
        self.present(actionSheet, animated: true)
    }
    
    func getFirstLine(text: String) -> String{
        return text.components(separatedBy: "\n")[0]
    }
    @IBAction func onDoneTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onPickColor(_ sender: Any) {

        let categoryColorView = CategoryColorView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        categoryColorView.delegate = self
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(categoryColorView)
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.delegate?.editNote(note: self.note!, state: noteState)
       _ = navigationController?.popViewController(animated: true)
    }
}

extension DetailNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if note.titleEdited {
            try! realm.write {
                 note?.content = textView.text
            }
        } else {
            titleTextField.text = getFirstLine(text: textView.text)
            try! realm.write {
                note?.content = textView.text
                note?.title = titleTextField.text!
            }
        }
    }
}

extension DetailNoteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)! {
            try! realm.write {
                note.titleEdited = true
                note?.title = textField.text!
            }
        }
    }
}
extension DetailNoteViewController: CategoryColorViewDelegate {
    func onColorButtonTap(category: CategoryColor) {
        try! realm.write {
            note?.category?.color = category
        }
        setColor(color: category)
    }
}


