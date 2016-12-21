//
//  AppDelegate.swift
//  OneLineToggl
//
//  Created by Alex Mishyn on 19/12/2016.
//  Copyright © 2016 Alex Mishyn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if #available(OSX 10.12.2, *) {
            if ((NSClassFromString("NSTouchBar")) != nil) {
                NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

