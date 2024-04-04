//
//  TasksView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 01/04/24.
//

import SwiftUI
import CoreData

struct TasksView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.startDate, ascending: true)],
                  animation: .default)
    private var assignments: FetchedResults<Assignment>
    
    @Binding var currentDay: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(7..<23) { hour in
                            let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
                            let formattedHour = hour < 10 ? "0\(hour)" : "\(hour)"
                            let formattedMinute = Calendar.current.component(.minute, from: date) < 10 ? "0\(Calendar.current.component(.minute, from: date))" : "\(Calendar.current.component(.minute, from: date))"
                            
                            HStack {
                                Text("\(formattedHour):\(formattedMinute)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Color.secondary
                                    .frame(height: 0.35)
                            }
                            .frame(height: 80.0)
                        }
                    }
                    // The magic begins
                    ForEach(assignments.filter { Calendar.current.isDate($0.startDate!, inSameDayAs: currentDay) }) { event in
                        TaskRowView(event: event)
                            .padding(.top)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
