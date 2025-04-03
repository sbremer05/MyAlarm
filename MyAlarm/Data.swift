//
//  Data.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/3/25.
//

import Foundation
import SwiftData

@MainActor
class Data {
    static let shared = Data()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            Alarm.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Couldn't create ModelContainer: \(error)")
        }
    }
}
