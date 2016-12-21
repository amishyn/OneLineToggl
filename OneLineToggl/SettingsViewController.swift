    //
//  SettingsViewController.swift
//  OneLineToggl
//
//  Created by Alex Mishyn on 20/12/2016.
//  Copyright © 2016 Alex Mishyn. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{

    var projects: [[String:Any]] = [[:]]
    var callback: ()->Void = {}
    
    //    [
    //    "name": "***REMOVED***",
    //    "shortcuts": "ks",
    //    "pid": "***REMOVED***",
    //    ],
    //    [
    //    "name": "***REMOVED***",
    //    "shortcuts": "p2b",
    //    "pid": "***REMOVED***",
    //    ]

    
    @IBOutlet weak var userTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!

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
        
        self.projects = UserDefaults.standard.value(forKey: "projects") as! [[String:Any]]
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.callback()
        self.dismiss(sender)
    }
    @IBAction func saveTapped(_ sender: Any) {
        UserDefaults.standard.setValue(self.userTextField.stringValue, forKey: "user")
        UserDefaults.standard.setValue(self.passwordTextField.stringValue, forKey: "password")
        UserDefaults.standard.setValue(self.projects, forKey: "projects")
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.projects.count
    }


    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.title == "image" {
            
            let imageData = self.projects[row]["image"]
            
            if imageData != nil {
                let image = NSImage(data: (imageData as! NSData) as Data)
                return image
            } else {
                return nil
            }
        } else {
            return self.projects[row][(tableColumn?.title)!]
        }
    }
    
    @IBAction func addProjectTapped(_ sender: Any) {
        self.projects.append([String:Any]())
        self.tableView.reloadData()
    }

    @IBAction func deleteProject(_ sender: Any) {
        self.projects.remove(at: self.tableView.selectedRow)
        self.tableView.reloadData()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        print("Change image", self.tableView.selectedRow)
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { (a) in
            if openPanel.urls.first != nil {
                print("done", a, openPanel.urls)
                let image = NSImage(byReferencing: openPanel.urls.first!)
                self.projects[self.tableView.selectedRow]["image"] = image.tiffRepresentation
                
                UserDefaults.standard.set(self.projects as! NSArray, forKey: "projects")
                print("image saved")
            }
        }
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        self.projects[row][(tableColumn?.title)!] = object!
        UserDefaults.standard.set(self.projects as! NSArray, forKey: "projects")        
    }

}
