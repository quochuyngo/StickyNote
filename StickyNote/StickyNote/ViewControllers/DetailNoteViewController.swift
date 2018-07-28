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
import PassKit
import TOPasscodeViewController

protocol DetailNoteViewControllerDelegate {
    func editNote(note: Note, state: NoteState)
    func deleteNote(note:Note)
}
class DetailNoteViewController: BaseViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryColorButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeCreatedLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    let settingPassCodeVC = TOPasscodeSettingsViewController(style: .light)
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var note:Note?
    var delegate: DetailNoteViewControllerDelegate?
    var noteState: NoteState!
    //var passwordContainerView: PasswordContainerView!
    let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        NotificationCenter.default.addObserver(self, selector: #selector(DetailNoteViewController.keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailNoteViewController.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setEditorStates(isEditing: false)
    
        /*editTextView.undoManager?.registerUndo(withTarget: self, handler: {
            _ in
        })*/
        
        //categoryColorButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        //editTextView.contentSize.height = size.height + 40
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
            editTextView.text = note.content
            titleTextField.text = note.title
            timeCreatedLabel.text = note.formatFullDateTime()
        }
        else {
            noteState = .new
            note = Note()
            navigationController?.navigationBar.barTintColor = Color.yellow
            categoryColorButton.backgroundColor = Color.yellow
        }
      
    }

    func setColor(color: CategoryColor) {
        let color = ColorManager.shared.getColor(with: color)
        editTextView.backgroundColor = color.bgColor
        timeView.backgroundColor = color.bgColor
        navigationController?.navigationBar.barTintColor = color.color
        categoryColorButton.backgroundColor = color.color
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
    
    
    func getFirstLine(text: String) -> String{
        return text.components(separatedBy: "\n")[0]
    }
    
    @IBAction func onSelectColorTap(_ sender: UIButton) {
        let categoryColorView = CategoryColorView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        categoryColorView.delegate = self
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(categoryColorView)
        }
        //editTextView.undoManager?.undo()
    }
    
    @IBAction func onOptionTap(_ sender: UIButton) {
        guard let note = note else { return }
        let actionSheet = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: note.isLocked ? NoteOptions.unlock.rawValue : NoteOptions.lock.rawValue, style: .default, handler: {
            UIAlertAction in
            
            if !note.isLocked {
                if PassCodeManager.passCode == nil {
                self.settingPassCodeVC.delegate = self
                    self.navigationController?.pushViewController(self.settingPassCodeVC, animated: true)
                    
                } else {
                    self.showInputPasscode(in: self, delegate: self)
                }
            } else {
                try! realm.write {
                    note.isLocked = false
                }
            }
            
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
    
    @IBAction func onBackTap(_ sender: UIBarButtonItem) {
        if let note = note {
            self.delegate?.editNote(note: note, state: noteState)
        }
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func onDoneTap(_ sender: Any) {
        view.endEditing(true)
    }
}

extension DetailNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let note = note else { return }
        if note.titleEdited {
            try! realm.write {
                 note.content = textView.text
            }
        } else {
            titleTextField.text = getFirstLine(text: textView.text)
            try! realm.write {
                note.content = textView.text
                note.title = titleTextField.text!
            }
        }
    }
}

extension DetailNoteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let note = note else { return }
        if !(textField.text?.isEmpty)! {
            try! realm.write {
                note.titleEdited = true
                note.title = textField.text!
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

extension DetailNoteViewController: TOPasscodeViewControllerDelegate {
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        guard let note = note else { return false }
        if code == PassCodeManager.passCode {
            try! realm.write {
                note.isLocked = true
            }
            return true
        } else {
            return false
        }
    }
    
    func didTapCancel(in passcodeViewController: TOPasscodeViewController) {
        dismiss(animated: true, completion: nil)
    }
}


extension DetailNoteViewController: TOPasscodeSettingsViewControllerDelegate {
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didAttemptCurrentPasscode passcode: String) -> Bool {
        return true
    }
    
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didChangeToNewPasscode passcode: String, of type: TOPasscodeType) {
        guard let note = note else { return }
        PassCodeManager.passCode = passcode
        try! realm.write {
            note.isLocked = true
        }
        navigationController?.popViewController(animated: true)
    }
    
}
