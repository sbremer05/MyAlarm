//
//  ContentView.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        FilteredAlarmList()
    }
}

#Preview {
    ContentView()
        .modelContainer(Data.shared.modelContainer)
}
