//
//  FilteredAlarmList.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/3/25.
//

import SwiftUI

struct FilteredAlarmList: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationSplitView {
            AlarmList(nameFilter: searchText)
                .searchable(text: $searchText)
        } detail: {
            Text("Select an alarm")
                .navigationTitle("Alarm")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilteredAlarmList()
        .modelContainer(Data.shared.modelContainer)
}
