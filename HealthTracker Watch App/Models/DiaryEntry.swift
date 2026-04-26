//
//  DiaryEntry.swift
//  HealthTracker
//
//  Created by David Emery on 4/26/26.
//

import Foundation
import SwiftUI
import Combine

enum EntryType: String, Codable, CaseIterable {
    case calories = "Calories"
    case water = "Water"
    
    var icon: String{
        switch self{
        case .calories: return "flame.fill"
        case .water: return "drop.fill"
        }
    }
        
        var color: Color{
            switch self{
            case .calories: return .orange
            case .water: return .cyan
            }
        
    }
}

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    let type: EntryType
    let value: Double
    let timestamp: Date
    
    init(id: UUID = UUID(), type: EntryType, value: Double, timestamp: Date = Date()){
        self.id = id
        self.type = type
        self.value = value
        self.timestamp = timestamp
    }
}
