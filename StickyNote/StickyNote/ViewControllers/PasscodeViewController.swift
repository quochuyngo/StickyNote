//
//  PasscodeViewController.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/11/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController {

    @IBOutlet weak var code4: UIImageView!
    @IBOutlet weak var code3: UIImageView!
    @IBOutlet weak var code2: UIImageView!
    @IBOutlet weak var code1: UIImageView!
        @IBOutlet weak var pass1: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        pass1.delegate = self
        pass1.becomeFirstResponder()
    }


    func setPassCode(numberOfCodes: Int) {
        switch numberOfCodes {
        case 0:
            code1.image = UIImage(named: "ic_minus")
            code2.image = UIImage(named: "ic_minus")
            code3.image = UIImage(named: "ic_minus")
            code4.image = UIImage(named: "ic_minus")
            break
        case 1:
            code1.image = UIImage(named: "ic_circle2")
            code2.image = UIImage(named: "ic_minus")
            code3.image = UIImage(named: "ic_minus")
            code4.image = UIImage(named: "ic_minus")
            break
        case 2:
            code1.image = UIImage(named: "ic_circle2")
            code2.image = UIImage(named: "ic_circle2")
            code3.image = UIImage(named: "ic_minus")
            code4.image = UIImage(named: "ic_minus")
            break
        case 3:
            code1.image = UIImage(named: "ic_circle2")
            code2.image = UIImage(named: "ic_circle2")
            code3.image = UIImage(named: "ic_circle2")
            code4.image = UIImage(named: "ic_minus")
            break
        case 4:
            code1.image = UIImage(named: "ic_circle2")
            code2.image = UIImage(named: "ic_circle2")
            code3.image = UIImage(named: "ic_circle2")
            code4.image = UIImage(named: "ic_circle2")
            break
        default:
            break
        }
    }
}

extension PasscodeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("dfsf")
        setPassCode(numberOfCodes: (textField.text?.characters.count)!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      print("dfsf")
    }
}
