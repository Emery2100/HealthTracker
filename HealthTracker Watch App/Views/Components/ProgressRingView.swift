//
//  ProgressRingView.swift
//  HealthTracker
//
//  Created by David Emery on 4/26/26.
//

import SwiftUI

struct ProgressRingView: View {
    
    let color: Color
    let progress: Double
    let icon: String
    let size: CGFloat
    
    var body: some View {
        ZStack{
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 8)
            
            //Overlap Progress circle (trimmed circle)
            Circle()
                .trim(from: 0, to : progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration:0.4), value: progress)
            
            Image(systemName: icon)
                .font(.system(size: size * 0.5))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}
