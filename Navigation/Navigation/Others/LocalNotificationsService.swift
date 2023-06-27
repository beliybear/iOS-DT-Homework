//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Beliy.Bear on 26.06.2023.
//

import Foundation
import UserNotifications

class LocalNotificationsService {
    
    func registeForLatestUpdatesIfPossible() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let notificationOptions: UNAuthorizationOptions = [.sound, .badge, .provisional]
        notificationCenter.requestAuthorization(options: notificationOptions) { granted, error in
            guard granted else {
                print("Local Notifications Authorization denied.")
                return
            }
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Посмотрите последние обновления"
            
            var notificationDateComponents = DateComponents()
            notificationDateComponents.hour = 19
            
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: true)
            
            let notificationRequest = UNNotificationRequest(identifier: "dailyUpdates", content: notificationContent, trigger: notificationTrigger)
            
            notificationCenter.add(notificationRequest) { error in
                if let error = error {
                    print("Error adding daily updates notification: \(error)")
                }
            }
        }
    }
}

