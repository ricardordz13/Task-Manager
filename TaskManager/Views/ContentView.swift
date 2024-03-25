//
//  ContentView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 21/03/24.
//

import SwiftUI

struct ContentView: View {
    // Formatted Date
    @State private var currentDate: Date = .init()
    // Week Slider
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeek: Int = 1
    @State private var createWeek: Bool = false
    
    var body: some View {
        VStack {
            Header()
            Spacer()
        }
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
        .padding()
    }
    
    // Header
    @ViewBuilder
    func Header() -> some View {
        VStack {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(currentDate.formatted(date: .complete, time: .omitted))
                        .textCase(.uppercase)
                        .font(.footnote)
                        .foregroundColor(Color.secondary)
                    
                    Group {
                        Text(currentDate.format("MMMM "))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary) +
                        Text(currentDate.format("YYYY"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.teal)
                    }
                }
                
                Spacer()
                
                Image(systemName: "person.fill")
                    .font(.title2)
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 90)
                            .fill(.ultraThinMaterial)
                    )
                    .accessibility(label: Text("Account Settings"))
                    .accessibility(addTraits: .isButton)
            }
            
            // Week Slider
            TabView(selection: $currentWeek) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        //.padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 75)
            .onChange(of: currentWeek, initial: false) { oldValue, newValue in
                if newValue == 0 || newValue == (weekSlider.count - 1) {
                    createWeek = true
                }
            }
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    Text(day.date.format("dd"))
                        .font(.caption)
                        .frame(width: 35, height: 35)
                        .fontWeight(.medium)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .secondary)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.teal)
                            }
                            
                            // Show today is today
                            if day.date.isToday {
                                
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
