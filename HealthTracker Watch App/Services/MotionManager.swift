//
//  MotionManager.swift
//  HealthTracker
//
//  Created by David Emery on 5/11/26.
//

import CoreMotion
import Foundation
import Combine

class MotionManager: ObservableObject {
    static let shared = MotionManager()
    
    @Published var accelerometerData: (x: Double, y: Double, z: Double) = (0, 0, 0)
    @Published var gyroscopeData: (x: Double, y: Double, z: Double) = (0, 0, 0)  
    @Published var currentUserActivity: ActivityType?
    
    @Published var errorMessage: String?
    @Published var shakeDetected: Bool = false
    
    private let motionManager = CMMotionManager()
    private let activityManager = CMMotionActivityManager()
    private let updateInterval: TimeInterval = 0.1
    
    private var shakeThreshold: Double = 2.5
    private var lastShakeTime: Date = .distantPast
    private var shakeDebounceInterval: TimeInterval = 1.0
    
    
    var isAccelerometerAvailable: Bool {
        motionManager.isAccelerometerActive
    }

    var isGyroscopeAvailable: Bool {
        motionManager.isGyroAvailable
    }

    var isActivityAvailable: Bool {
        CMMotionActivityManager.isActivityAvailable()
    }
    
    private init() {
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval
    }
    
    
    func startShakeDetection() {
        startActivityUpdates()
    }
    
    func startActivityTracking() {
        startActivityUpdates()
    }
    
    private func startAccelerometer() {
        guard isAccelerometerAvailable else {
            errorMessage = "Accelerometer Not Available"
            return
        }

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else {
                if let error = error {
                    self?.errorMessage = "Accelerometer not available"
                }
                return
            }
            
            self.accelerometerData = (
                x: data.acceleration.x,
                y: data.acceleration.y,
                z: data.acceleration.z,
            )
            
            self.detectShake(acceleration: data.acceleration)
        }
    }
    
    private func startGyroscope() {
        guard isGyroscopeAvailable else {
            return
        }
        
        motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else {
                return
            }
            
            self.gyroscopeData = (
                x: data.rotationRate.x,
                y: data.rotationRate.y,
                z: data.rotationRate.z
            )
        }
    }
    
    private func startActivityUpdates() {
        guard isActivityAvailable else {
            return
        }
        
        activityManager.startActivityUpdates(to: .main) { [weak self] activityData in
            guard let self = self, let activityData = activityData else {
                return
            }
            
            self.currentUserActivity = ActivityType.from(activityData)
        }
    }
    
    private func detectShake(acceleration: CMAcceleration) {
        let magnitude = sqrt(
            pow(acceleration.x, 2) +
            pow(acceleration.y, 2) +
            pow(acceleration.z, 2)
        )
        
        let now = Date()
        if magnitude > shakeThreshold && now.timeIntervalSince(lastShakeTime) > shakeDebounceInterval {
            lastShakeTime = now
            
            DispatchQueue.main.async {
                self.shakeDetected = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.shakeDetected = false
                }
            }
        }
    }
    

}
