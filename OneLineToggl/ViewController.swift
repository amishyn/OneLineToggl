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

class ViewController: NSViewController {
    let slang = ["#ks": ***REMOVED***, "#p2b": ***REMOVED***]
    
    @IBOutlet weak var slangLabel: NSTextField!
    @IBOutlet weak var lastActivity: NSTextField!
    @IBOutlet weak var textField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.slangLabel.stringValue = slang.description
        
        self.view.window?.makeFirstResponder(self.textField)
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
            
            let user = "***REMOVED***"
            let password = "api_token"
            
            if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            
            Alamofire.request("https://www.toggl.com/api/v8/time_entries", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
                self.textField.stringValue = ""
                self.lastActivity.stringValue = "\(title) \(project)"
            }
            
        }

    }
    
}


