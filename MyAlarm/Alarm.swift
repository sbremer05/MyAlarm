//
//  Alarms.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/1/25.
//

import Foundation
import SwiftData

@Model
class Alarm {
    var name: String
    var descript: String
    var date: Date
    var repeats: Bool
    var dayRepeat: Int
    
    init(name: String, descript: String, date: Date, repeats: Bool, dayRepeat: Int) {
        self.name = name
        self.descript = descript
        self.date = date
        self.repeats = repeats
        self.dayRepeat = dayRepeat
    }
}
