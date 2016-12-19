//
//  MyWindowController.swift
//  OneLineToggl
//
//  Created by Alex Mishyn on 19/12/2016.
//  Copyright © 2016 Alex Mishyn. All rights reserved.
//

import Cocoa

class MyWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    @IBAction func buttonTapped(_ sender: Any) {
        print("tapped")
    }

}
