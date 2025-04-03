//
//  MyAlarmApp.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/1/25.
//

import SwiftUI

@main
struct MyAlarmApp: App {
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Alarm.self])
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
}
