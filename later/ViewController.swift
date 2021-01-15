//
//  ViewController.swift
//  reminders
//
//  Created by nicolai92 on 19.12.19.
//  Copyright © 2019 nicolai92. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var reminderContentText: NSTextField!
    @IBOutlet weak var reminderWhenText: NSTextField!
    @IBOutlet weak var reminderOkButton: NSButton!
    @IBOutlet weak var reminderQuitButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        reminderOkButton.action = #selector(ViewController.setNotificationText)
        reminderQuitButton.action = #selector(ViewController.quitApplication)
    }
    
    @IBAction func quitApplication(_ sender: NSButton) {
        exit(0)
    }
    
    @IBAction func setNotificationText(_ sender: NSButton) {
        /*
            Get content of NSTextFields
         */
        let textContent = reminderContentText.stringValue
        let whenContent = reminderWhenText.stringValue
        
        // Get a reference to the AppDelegate to close the Popover
        let appDelegate = NSApp.delegate as? AppDelegate
        
        /*
            Alert, if either text or when is empty, or both
         */
        if (textContent.isEmpty || whenContent.isEmpty) {
            appDelegate!.closePopover(sender: sender)
            return
        }
        
        // Check, which format is used
        if (isHour(input: whenContent)) {
            NSLog("Format seems to be hours.")
            if let number = intOfString(input: whenContent) {
                scheduleEventNotification(textContent, 60*60*number)
            }
        }
        else if (isMinute(input: whenContent)) {
            NSLog("Format seems to be minutes.")
            if let number = intOfString(input: whenContent) {
                scheduleEventNotification(textContent, 60*number)
            }
        }
        else if (isSecond(input: whenContent)) {
            NSLog("Format seems to be seconds.")
            if let number = intOfString(input: whenContent) {
                scheduleEventNotification(textContent, number)
            }
        }
        else {
            NSLog("Unsupported format.")
            alertNotification(question: "Unsupported format", text: "It seems like the format that you entered for a reminder is not valid or supported.")
        }
        
        appDelegate!.closePopover(sender: sender)
    }
    
    /*
        Supported Formats
     */
    func isSupportedFormat(input: String, formats: [String]) -> Bool {
        // Check, whether an input string is supported
        for format in formats {
            if (input.lowercased().range(of:format) != nil) {
                return true
            }
        }
        // input string is not supported
        return false
    }
    
    func isHour(input: String) -> Bool {
        
        let supportedFormats = ["hr", "hr.", "hrs", "hrs.", "hour", "hours", "std", "std.", "stunde", "stunden"]
        return isSupportedFormat(input: input, formats: supportedFormats)
    }
    
    func isMinute(input: String) -> Bool {
        
        let supportedFormats = ["min", "min.", "mins", "mins.", "minute", "minutes", "minuten"]
        return isSupportedFormat(input: input, formats: supportedFormats)
    }
    
    func isSecond(input: String) -> Bool {
        
        let supportedFormats = ["s", "s.", "sec", "sec.", "secs", "secs.", "second", "seconds", "sek", "sek.", "sekunde", "sekunden"]
        return isSupportedFormat(input: input, formats: supportedFormats)
    }

    /*
        Parse integer from string
     */
    func intOfString(input: String) -> Int? {
        if let number = Int(input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            return number
        }
        return nil
    }
}

extension ViewController {
    
    static func freshController() -> ViewController {
    // 1. Get a reference to Main.storyboard
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    // 2. Create a Scene identifier that matches the one set just before.
    let identifier = NSStoryboard.SceneIdentifier("ViewController")
    // 3. Instantiate CalendarViewController and return it
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController
        else {
            fatalError("Cannot find ViewController. Please check Main.storyboard ...")
        }
    return viewcontroller
    }
}
