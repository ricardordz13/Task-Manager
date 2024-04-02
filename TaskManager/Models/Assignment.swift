//
//  Assignment.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 31/03/24.
//

import SwiftUI
import SwiftData
import CloudKit

@Model
class Assignment: Identifiable {
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var title: String = ""
    var isComplete: Bool = false
    var category: String = ""

    init(startDate: Date, endDate: Date, title: String, isComplete: Bool = false, category: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.isComplete = isComplete
        self.category = category
    }
    
    var categoryColor: Color {
        switch category {
        case "CategoryColor1": return .red
        case "CategoryColor2": return .blue
        case "CategoryColor3": return .green
        case "CategoryColor4": return .yellow
        default: return .teal
        }
    }
}
