//
//  AppDelegate.swift
//  Reminders
//
//  Created by nicolai92 on 18.12.19.
//  Copyright © 2019 nicolai92. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // Icon in macOS menu bar
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    // Controller
    let popover = NSPopover()
    
    // User settings
    let defaults = UserDefaults.standard
    
    // Global events
    var detector: AnyObject?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Display icon in macOS menu bar
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("MenuIcon"))
            button.action = #selector(togglePopover(_:))
        }
        
        popover.contentViewController = ViewController.freshController()
        
        // Check for mouse events
        detector = NSEvent.addGlobalMonitorForEvents(matching:[NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown], handler: { [weak self] event in self?.closePopover(sender: event) }) as AnyObject
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    /**
        Popover functionality
     */
    @objc func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
        
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
    }
}
