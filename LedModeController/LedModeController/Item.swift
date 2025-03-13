//
//  Item.swift
//  LedModeController
//
//  Created by 長峯幸佑 on 2025/03/13.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
