//
//  OffsetKey.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 25/03/24.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
