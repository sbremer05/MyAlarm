//
//  CountdownView.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/3/25.
//

import SwiftUI

struct CountdownView: View {
    let targetDate: Date
    @State private var remainingTime: String = "Loading..."
    
    var body: some View {
        Text(remainingTime)
            .onAppear {
                updateCountdown()
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                updateCountdown()
            }
    }

    private func updateCountdown() {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: now, to: targetDate)

        var parts: [String] = []

        if let years = components.year, years > 0 { parts.append("\(years) year\(years > 1 ? "s" : "")") }
        if let months = components.month, months > 0 { parts.append("\(months) month\(months > 1 ? "s" : "")") }
        if let weeks = components.weekOfYear, weeks > 0 { parts.append("\(weeks) week\(weeks > 1 ? "s" : "")") }
        if let days = components.day, days > 0 { parts.append("\(days) day\(days > 1 ? "s" : "")") }

        if let hours = components.hour, let minutes = components.minute, let seconds = components.second, (components.day ?? 0) == 0 {
            parts = [String(format: "%02d:%02d:%02d", hours, minutes, seconds)]
        }

        DispatchQueue.main.async {
            remainingTime = parts.isEmpty ? "Expired" : parts.joined(separator: ", ")
        }
    }
}
