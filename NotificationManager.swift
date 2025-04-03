//
//  NotificationManager.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/3/25.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}

    func scheduleNotifications(for alarm: Alarm, reminders: [TimeInterval]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [alarm.name]) // Remove old notifications

        for reminder in reminders {
            let notificationTime = alarm.date.addingTimeInterval(-reminder)
            if notificationTime > Date() { // Schedule only future notifications
                let content = UNMutableNotificationContent()
                content.title = "Alarm Reminder"
                content.body = "\(alarm.name) is due in \(Int(reminder / 60)) minutes!"
                content.sound = .default

                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
    }
}
