    //
//  SettingsViewController.swift
//  OneLineToggl
//
//  Created by Alex Mishyn on 20/12/2016.
//  Copyright © 2016 Alex Mishyn. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    @IBOutlet weak var userTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserDefaults.standard.string(forKey: "user")
        let pass = UserDefaults.standard.string(forKey: "password")
        if user != nil {
            self.userTextField.stringValue = user!
        }
        if pass != nil {
            self.passwordTextField.stringValue = pass!
        }
    }
    
    
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(sender)
    }
    @IBAction func saveTapped(_ sender: Any) {
        UserDefaults.standard.setValue(self.userTextField.stringValue, forKey: "user")
        UserDefaults.standard.setValue(self.passwordTextField.stringValue, forKey: "password")
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.projects.count
    }

    let projects = [
        [
            "name": "***REMOVED***",
            "shortcuts": "ks",
            "pid": "***REMOVED***",
            "image": "***REMOVED***"
        ],
        [
            "name": "***REMOVED***",
            "shortcuts": "p2b",
            "pid": "***REMOVED***",
            "image": "***REMOVED***"
        ]
    ]

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.title == "image" {
            let name = self.projects[row]["image"]
            if name != nil {
                let image = NSImage(named: name!)
                return image
            } else {
                return nil
            }
        } else {
            return self.projects[row][(tableColumn?.title)!]
        }
    }
    


    @IBAction func aaaa(_ sender: Any) {
    }
}
