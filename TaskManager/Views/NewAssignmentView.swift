//
//  NewAssignmentView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 01/04/24.
//

import SwiftUI

struct NewAssignmentView: View {
    @Environment(\.dismiss) private var dismiss
    
    // To Save Data
    @Environment(\.modelContext) private var context

    @State private var taskTitle: String = ""
    @State private var startDate: Date = .init()
    @State private var endDate: Date = .init()
    
    var body: some View {
        VStack(alignment: .leading){
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            VStack(alignment: .leading) {
                Text("Text title")
                    .font(.caption)
                    .foregroundStyle(.primary)
                
                TextField("Learn SwiftUI", text: $taskTitle)
            }
            
            VStack(alignment: .leading) {
                Text("Start Date")
                    .font(.caption)
                    .foregroundStyle(.primary)
                    
                DatePicker("", selection: $startDate)
                    .datePickerStyle(.compact)
            }

            VStack(alignment: .leading) {
                Text("End Date")
                    .font(.caption)
                    .foregroundStyle(.primary)
                    
                DatePicker("", selection: $endDate)
                    .datePickerStyle(.compact)
            }
            
            Button {
                let assignment = Assignment(startDate: startDate, endDate: endDate, title: taskTitle, category: "red")
                do {
                    context.insert(assignment)
                    try context.save()
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text("Create Task")
                    .font(.title3)
                    .textScale(.secondary)
                    .foregroundColor(.white)
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .center)
                    .padding(15)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.teal)
            )
            .padding(.vertical)
        }
        .padding()
    }
}

func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return calendar.date(from: dateComponents) ?? .now
}

#Preview {
    NewAssignmentView()
}
