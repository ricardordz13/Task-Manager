//
//  TasksView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 01/04/24.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Binding var currentDay: Date
    
    // Dynamic Query
    @Query private var assignments: [Assignment]
    init(currentDay: Binding<Date>, isChecked: Bool = false) {
        self._currentDay = currentDay
        self.isChecked = isChecked
        // Predicate
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDay.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
        let predicate = #Predicate<Assignment> {
            return $0.startDate >= startOfDate && $0.startDate < endOfDate
        }
        // Sorting ??
        let sortDescriptor = [
            SortDescriptor(\Assignment.startDate, order: .reverse)
        ]
        self._assignments = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    
    @State private var isChecked = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        /*
                         HStack {
                         Text(context.date, format: .dateTime.hour().minute())
                         .font(.caption)
                         .foregroundColor(.teal)
                         Color.teal
                         .frame(height: 0.5)
                         }
                         */
                                                
                        ForEach(7..<23) { hour in
                            // hours per day
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
                    ForEach(assignments) { event in
                        TaskRowView(event: event)
                            .padding(.top)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

/*
func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return calendar.date(from: dateComponents) ?? .now
}
*/
