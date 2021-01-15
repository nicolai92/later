//
//  Notification.swift
//  Reminders
//
//  Created by nicolai92 on 29.10.20.
//  Copyright © 2020 nicolai92. All rights reserved.
//

import Cocoa
import Foundation
import UserNotifications

func requestNotificationAuthorization() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
        if granted {
            NSLog("Access to notifications granted")
        } else {
            NSLog("Access to notifications denied")
        }
    }
}

func scheduleEventNotification(_ text: String, _ when: Int) {
    requestNotificationAuthorization() // Best practices by Apple
    
    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = "Reminder"
    content.body = text
    content.categoryIdentifier = "EVENT"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(when), repeats: false)
    let request = UNNotificationRequest(identifier: "NEXT_REMINDER", content: content, trigger: trigger)
    center.add(request)
}

func alertNotification(question: String, text: String) {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

