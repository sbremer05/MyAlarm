//
//  AlarmDetail.swift
//  MyAlarm
//
//  Created by Sean Bremer on 4/2/25.
//

import SwiftUI

struct AlarmDetail: View {
    @Bindable var alarm: Alarm
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var showEmptyNameAlert = false
    
    init(alarm: Alarm, isNew: Bool = false) {
        self.alarm = alarm
        self.isNew = isNew
    }
    
    var body: some View {
        Form {
            TextField("Alarm Name", text: $alarm.name)
            
            TextField("Description", text: $alarm.descript)
            
            Toggle("Repeat", isOn: $alarm.repeats)
            
            if(alarm.repeats) {
                HStack {
                    Text("Repeat every")
                        .frame(width: 100, alignment: .leading)
                    
                    Picker("", selection: $alarm.dayRepeat) {
                        ForEach(1..<365, id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .clipped()
                    .disabled(!alarm.repeats)
                    .padding(.horizontal, 10)
                    
                    Text("days")
                        .frame(width: 40, alignment: .leading)
                }
                .padding(.vertical, 5)
            }
            
            DatePicker("Time", selection: $alarm.date, in: Date()...)
        }
        .navigationTitle(isNew ? "New Alarm": "Alarm")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        validateAndDismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        context.delete(alarm)
                        dismiss()
                    }
                }
            } else {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        validateAndDismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
        .alert("Name Required", isPresented: $showEmptyNameAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a name for your alarm.")
        }
        .navigationBarBackButtonHidden(!isNew)
    }
    
    private func validateAndDismiss() {
        if alarm.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showEmptyNameAlert = true
        } else {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        AlarmDetail(alarm: Alarm(name: "Morning Alarm", descript: "Wake up and start the day!", date: .now, repeats: false, dayRepeat: 1), isNew: false)
    }
    .modelContainer(Data.shared.modelContainer)
}
