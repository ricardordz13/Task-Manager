//
//  Assignment.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 31/03/24.
//

import Foundation
import SwiftUI

struct Assignment: Identifiable {
    let id = UUID()
    var startDate: Date
    var endDate: Date
    var title: String
    var isComplete: Bool = false
    var category: Color
}

let assignments: [Assignment] = [
    .init(startDate: dateFrom(9,5,2023,7,0), endDate: dateFrom(9,5,2023,8,0), title: "Event 1", category: .yellow),
    .init(startDate: dateFrom(9,5,2023,9,0), endDate: dateFrom(9,5,2023,10,0), title: "Event 2", category: .green),
    .init(startDate: dateFrom(9,5,2023,11,0), endDate: dateFrom(9,5,2023,12,00), title: "Event 3", category: .red),
    .init(startDate: dateFrom(9,5,2023,13,0), endDate: dateFrom(9,5,2023,14,45), title: "Event 4", category: .blue),
    .init(startDate: dateFrom(9,5,2023,15,0), endDate: dateFrom(9,5,2023,15,45), title: "Event 5", category: .brown),
]
