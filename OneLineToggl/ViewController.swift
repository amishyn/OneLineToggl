//
//  ViewController.swift
//  OneLineToggl
//
//  Created by Alex Mishyn on 19/12/2016.
//  Copyright © 2016 Alex Mishyn. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftDate

class ViewController: NSViewController, NSTouchBarDelegate  {
    var slang = [String:String]()
    
    @IBOutlet weak var slangLabel: NSTextField!
    @IBOutlet weak var lastActivity: NSTextField!
    @IBOutlet weak var textField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
        // Do any additional setup after loading the view.
    }
    func update() {
        let projects = UserDefaults.standard.value(forKey: "projects") as! [[String:Any]]
        projects.map{
            if $0["shortcuts"] != nil && $0["pid"] != nil {
                let s = $0["shortcuts"] as! String
                let pid = $0["pid"] as! String
                self.slang[s] = pid
            }
        }
        var keys: [String] = []
        
        self.slang.forEach { (key, value) in
            keys.append(key)
        }
        self.slangLabel.stringValue = keys.joined(separator: ",")
    }

    
    func setProject(projectString: String) {
        self.textField.stringValue = "\(self.textField.stringValue) \(projectString)"
        self.submit(string: textField.stringValue)
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func done(_ sender: Any) {
        self.update()
        self.view.window?.makeFirstResponder(nil)
    }
    
    
    @IBAction func textFieldAction(_ sender: NSTextField) {
        self.view.window?.makeFirstResponder(nil)
        
        self.submit(string: sender.stringValue)
    }
    
    func submit(string: String) {
        var title = string
        print(string);
        
        var project: String = ""
        let pattern = "\\#\\w+"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = string as NSString
            let results = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))
            results.map {
                project = nsString.substring(with: $0.range)
                title = title.replacingOccurrences(of: project, with: "")
            }
            
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
        
        let togglProject = slang[project]
        if (togglProject != nil) {
            print("activity:", title, " @ ", project, togglProject!)
            
            var headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let date = Date()
            let dateInRegion = DateInRegion(absoluteDate: date)
            let serializedString:String = dateInRegion.iso8601()
            let parameters = [
                "time_entry": ["start": serializedString,
                               "description": title,
                               "pid": togglProject!,
                               "created_with": "One line",
                               "duration": -1*date.timeIntervalSince1970
                    ] as [String : Any]
            ]
            
            let user = UserDefaults.standard.value(forKey: "user") as! String
            let password = UserDefaults.standard.value(forKey: "password") as! String
            
            if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            
            Alamofire.request("https://www.toggl.com/api/v8/time_entries", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
                self.textField.stringValue = ""
                self.lastActivity.stringValue = "\(title) \(project)"
            }
            
        }
        
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let vc = segue.destinationController as! SettingsViewController
        vc.callback = {
            self.update()
            if #available(OSX 10.12.2, *) {
                self.view.window?.windowController?.makeTouchBar()
                self.view.window?.windowController?.showWindow(self)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
}


