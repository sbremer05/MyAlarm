//
//  ContentView.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/1/25.
//

import SwiftUI
import SwiftData

struct AlarmList: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Alarm.date, order: .forward) private var alarms: [Alarm]
    
    @State private var newAlarm: Alarm?
    @State private var showEmptyNameAlert = false
    @State private var alarmToValidate: Alarm?
    
    init(nameFilter: String = "") {
        let predicate = #Predicate<Alarm> { alarm in
            nameFilter.isEmpty || alarm.name.localizedStandardContains(nameFilter)
        }
        
        _alarms = Query(filter: predicate, sort: \Alarm.date, order: .forward)
    }
    
    var body: some View {
        List {
            ForEach(alarms) { alarm in
                HStack {
                    NavigationLink(alarm.name) {
                        AlarmDetail(alarm: alarm)
                            .onDisappear {
                                if alarm.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    alarmToValidate = alarm
                                    showEmptyNameAlert = true
                                }
                            }
                    }
                                
                    Spacer()
                                
                    CountdownView(targetDate: alarm.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .onDelete(perform: deleteAlarm(indexes:))
        }
        .navigationTitle("Alarms")
        .toolbar {
            ToolbarItem {
                Button(action: addAlarm) {
                    Label("Add Alarm", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .sheet(item: $newAlarm) { alarm in
            NavigationStack {
                AlarmDetail(alarm: alarm, isNew: true)
            }
            .interactiveDismissDisabled()
        }
        .alert("Name Required", isPresented: $showEmptyNameAlert) {
            Button("OK", role: .cancel) {
                if let alarm = alarmToValidate, alarm.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    alarm.name = "Unnamed Alarm"
                }
                alarmToValidate = nil
            }
        } message: {
            Text("Please enter a name for your alarm.")
        }
    }
    
    private func addAlarm() {
        let newAlarm = Alarm(name: "", descript: "", date: .now, repeats: false, dayRepeat: 0)
        context.insert(newAlarm)
        self.newAlarm = newAlarm
    }
    
    private func deleteAlarm(indexes: IndexSet) {
        for index in indexes {
            context.delete(alarms[index])
        }
    }
}

#Preview {
    NavigationStack {
        AlarmList()
            .modelContainer(Data.shared.modelContainer)
    }
}
