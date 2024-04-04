//
//  ContentView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 21/03/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // Formatted Date
    @State private var currentDate: Date = Date()
    // Week Slider
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeek: Int = 1
    @State private var createWeek: Bool = false
    // New Assignment
    @State private var createNewAssignment: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Header(currentDate: $currentDate) // Pass currentDate binding to Header
                .padding([.horizontal, .top])
            
            Divider()

            TasksView(currentDay: $currentDate) // Pass currentDate binding to TasksView
        }
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewAssignment.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(.teal, in: .circle)
            })
            .padding()
        })
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createLastWeek())
                }

                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
        .sheet(isPresented: $createNewAssignment, content: {
            NewAssignmentView()
        })
    }
    
    // Header
    @ViewBuilder
    func Header(currentDate: Binding<Date>) -> some View { // Pass currentDate binding
        VStack {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(currentDate.wrappedValue.formatted(date: .complete, time: .omitted)) // Use currentDate.wrappedValue
                        .textCase(.uppercase)
                        .font(.footnote)
                        .foregroundColor(Color.secondary)
                    
                    Group {
                        Text(currentDate.wrappedValue.format("MMMM ")) // Use currentDate.wrappedValue
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary) +
                        Text(currentDate.wrappedValue.format("YYYY")) // Use currentDate.wrappedValue
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.teal)
                    }
                }
                
                Spacer()
                
            }
            
            // Week Slider
            TabView(selection: $currentWeek) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 65)
            .onChange(of: currentWeek, perform: { newValue in
                if newValue == 0 || newValue == (weekSlider.count - 1) {
                    createWeek = true
                }
            })
        }
    }
    
    struct DayOfWeekView: View {
        let day: Date.WeekDay
        
        var body: some View {
            Text(day.date.format("E"))
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    DayOfWeekView(day: day)

                    Text(day.date.format("dd"))
                        .font(.caption)
                        .frame(width: 35, height: 35)
                        .fontWeight(.medium)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? (colorScheme == .dark ? .black : .white) : (day.date.isToday ? .teal : .secondary))
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                if day.date.isToday {
                                    Circle()
                                        .fill(.teal)
                                } else {
                                    Circle()
                                        .fill(.primary)
                                }
                            }
                        })
                }
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeek) {
            if let firstDate = weekSlider[currentWeek].first?.date, currentWeek == 0 {
                weekSlider.insert(firstDate.createLastWeek(), at: 0)
                weekSlider.removeLast()
                currentWeek = 1
            }
            
            if let lastDate = weekSlider[currentWeek].last?.date, currentWeek == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeek = weekSlider.count - 2
            }
        }
    }
}
