//
//  NewAssignmentView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 01/04/24.
//

import SwiftUI

struct NewAssignmentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss

    @State private var taskTitle: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
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
                    saveAssignment()
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
            .navigationBarTitle("New Assignment", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                saveAssignment()
            })
        }
    }

    private func saveAssignment() {
        guard !taskTitle.isEmpty else { return }

        let newAssignment = Assignment(context: managedObjectContext)
        newAssignment.title = taskTitle
        newAssignment.startDate = startDate
        newAssignment.endDate = endDate

        do {
            try managedObjectContext.save()
            dismiss()
        } catch {
            print("Error saving assignment: \(error.localizedDescription)")
        }
    }
}
