//
//  Assignment.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 31/03/24.
//

import Foundation
import SwiftUI
import SwiftData

struct Assignment: Identifiable {
    let id = UUID()
    var startDate: Date
    var endDate: Date
    var title: String
}
