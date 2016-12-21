//
//  MyWindowController.swift
//  OneLineToggl
//
//  Created by Alex Mishyn on 19/12/2016.
//  Copyright © 2016 Alex Mishyn. All rights reserved.
//

import Cocoa


class MyWindowController: NSWindowController, NSTouchBarDelegate {
    var projects: [[String: Any]] = []
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override func windowWillLoad() {
        self.updateProjects()
    }    
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        self.touchBar = nil
        
        self.updateProjects()
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        var identifiers = self.projects.filter({ $0["name"] != nil }).map{ NSTouchBarItemIdentifier(rawValue: $0["name"] as! String) }
        print(identifiers)
        identifiers.append(.otherItemsProxy)
        touchBar.defaultItemIdentifiers = identifiers
        
        return touchBar
    }
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        self.updateProjects()
        
        
        let project = self.projects.filter { (project) -> Bool in
            return project["name"] != nil && project["name"] as! String == identifier.rawValue
        }.first
        
        let item = NSCustomTouchBarItem(identifier: identifier)
        let name = project?["name"] as! String
        let imageData = project?["image"]
        if imageData != nil {
            let image = NSImage(data: (imageData as! NSData) as Data)
            let button = NSButton(image: image!, target: self, action: #selector(tapped))
            button.identifier = identifier.rawValue
            
            button.addConstraint(NSLayoutConstraint(
                item: button,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 80))
            
            item.view = button
        } else {
            let button = NSButton(title: name, target: self, action: #selector(tapped))
            button.identifier = identifier.rawValue
            item.view = button
        }
        
        return item

    }

    dynamic func tapped(sender: NSButton) {
        let identifier = sender.identifier!
        
        self.updateProjects()
        let project = self.projects.filter { (project) -> Bool in
            return project["name"] as! String == identifier
            }.first
        
        (self.contentViewController as! ViewController).setProject(projectString: project?["shortcuts"] as! String)
    }

    func updateProjects() {
        self.projects = UserDefaults.standard.value(forKey: "projects") as! [[String: Any]]
    }
}
