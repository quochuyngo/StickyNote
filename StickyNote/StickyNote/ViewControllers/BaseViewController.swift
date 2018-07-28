//
//  BaseViewController.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/10/18.
//  Copyright © 2018 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import TOPasscodeViewController

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showInputPasscode(in viewController: UIViewController, delegate: TOPasscodeViewControllerDelegate) {
        let passcodeVC = TOPasscodeViewController(style: .opaqueLight, passcodeType: .fourDigits)
        passcodeVC.delegate = delegate
        viewController.present(passcodeVC, animated: true, completion: nil)
    }
}
