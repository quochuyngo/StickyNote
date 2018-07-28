//
//  SettingViewController.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/10/18.
//  Copyright © 2018 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import QuickTableViewController
import TOPasscodeViewController

private final class CustomNavigationRow<T: UITableViewCell>: NavigationRow<T> {}
private final class CustomTapActionCell: TapActionCell {}
private final class CustomTapActionRow<T: TapActionCell>: TapActionRow<T> {}

class SettingViewController: QuickTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title = "Set Passcode"
        if PassCodeManager.passCode != nil {
            title = "Change Passcode"
        }
        tableContents = [
            Section(title: title, rows: [
                NavigationRow(title: title, subtitle: .none, action: { [weak self] _ in
                    if PassCodeManager.passCode != nil {
                        let passcodeVC = TOPasscodeViewController(style: .opaqueLight, passcodeType: .fourDigits)
                        passcodeVC.delegate = self
                        self?.present(passcodeVC, animated: true, completion: nil)
                    } else {
                        self?.showSettingVC()
                    }
                })
                ]),
            
        ]
        
        
        // Do any additional setup after loading the view.
    }
    
    func showSettingVC() {
        let settingPassCodeVC = TOPasscodeSettingsViewController(style: .light)
        settingPassCodeVC.delegate = self
        navigationController?.pushViewController(settingPassCodeVC, animated: true)
    }
    
    private func showLog() -> (Row) -> Void {
        return { _ in }
    }
    
    private func set(label: String) -> ((UITableViewCell, Row & RowStyle) -> Void) {
        return { cell, _ in
            cell.accessibilityLabel = label
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButtonTap(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingViewController: TOPasscodeViewControllerDelegate {
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        if code == PassCodeManager.passCode {
            showSettingVC()
            return true
        } else {
            return false
        }
    }
    
    func didTapCancel(in passcodeViewController: TOPasscodeViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: TOPasscodeSettingsViewControllerDelegate {
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didAttemptCurrentPasscode passcode: String) -> Bool {
        return true
    }
    
    func passcodeSettingsViewController(_ passcodeSettingsViewController: TOPasscodeSettingsViewController, didChangeToNewPasscode passcode: String, of type: TOPasscodeType) {
        PassCodeManager.passCode = passcode
        navigationController?.popViewController(animated: true)
    }
    
}
