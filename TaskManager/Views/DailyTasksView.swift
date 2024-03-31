//
//  DailyTasksView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 27/03/24.
//

import SwiftUI

struct DailyTasksView: View {
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
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Color.secondary
                                    .frame(height: 0.5)
                            }
                            .frame(height: 80.0)
                        }
                    }
                    // The magic begins
                    ForEach(assignments) { event in
                        eventCell2(event)
                            .padding(.top)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    func eventCell2(_ event: Assignment) -> some View {
        
        let duration = event.endDate.timeIntervalSince(event.startDate) / 3600
        let height = duration * 80.0
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: event.startDate)
        let minute = calendar.component(.minute, from: event.startDate)
        let offset = Double(hour-7) * (80.0)
        
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
                        .fill(event.category).opacity(0.3)
                )
                .padding(.leading, 10)
                .padding(.trailing, 30)
                .offset(x: 30, y: offset + 24)
        )
    }
}

func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return calendar.date(from: dateComponents) ?? .now
}

#Preview {
    DailyTasksView()
}
