//
//  HeartRateSample.swift
//  HealthTracker
//
//  Created by David Emery on 4/28/26.
//

import Foundation
import Combine

struct HeartRateSample: Identifiable {
    let id = UUID()
    let bpm: Double
    let timestamp: Date
    
    var formattedBPM: String  {
        "\(Int(bpm)) BPMs"
    }
}
