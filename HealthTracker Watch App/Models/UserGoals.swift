//
//  UserGoals.swift
//  HealthTracker
//
//  Created by David Emery on 4/28/26.
//

import Foundation

struct UserGoals: Codable {
    var dailyCaloriesGoal: Double
    var dailyWaterGoal: Double
    
    static let defaultGoals = UserGoals(
        dailyCaloriesGoal: 2000,
        dailyWaterGoal: 2000
    )
}
