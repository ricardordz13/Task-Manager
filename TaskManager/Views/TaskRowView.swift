//
//  TaskBlockView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 01/04/24.
//

import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Bindable var event: Assignment
    @State private var isChecked = false
    
    @Environment(\.modelContext) private var context

    var body: some View {
        
        let duration = event.endDate.timeIntervalSince(event.startDate) / 3600
        let height = duration * 80.0
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: event.startDate)
        let minute = calendar.component(.minute, from: event.startDate)
        let offset = (Double(hour-7) + Double(minute)/60) * 80.0
        
        print(hour, minute, Double(hour-7) + Double(minute)/60 )
        
        return (
            HStack {
                VStack(alignment: .leading) {
                    Group {
                        Text("\(event.startDate.formatted(.dateTime.hour().minute())) - \(event.endDate.formatted(.dateTime.hour().minute()))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Text(event.title)
                        .font(.footnote)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isChecked ? .primary : .secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .font(.subheadline)
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .frame(height: height)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                    //.fill(event.category).opacity(0.3)
                        .fill(.yellow).opacity(0.3)
                )
                .padding(.leading, 10)
                .padding(.trailing, 30)
                .contextMenu {
                    Button("Delete Task", role: .destructive) {
                        context.delete(event)
                        try? context.save()
                    }
                }
                .offset(x: 30, y: offset + 24)
        )
    }
}
