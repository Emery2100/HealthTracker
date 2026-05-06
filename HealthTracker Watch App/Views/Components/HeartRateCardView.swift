//
//  HeartRateCardView.swift
//  HealthTracker
//
//  Created by David Emery on 5/5/26.
//

import SwiftUI

struct HeartRateCardView: View {
    @ObservedObject var viewModel: HealthTrackerViewModel
    
    @State private var isHeartPulsing = false
    
    private var pulseDuration: Double {
        return 60.0 / viewModel.currentHeartRate
    }
    
    private var isBeating: Bool {
        viewModel.isMonitoringHeartRate
    }
    
    private func handleTapEvent() {
        if !viewModel.isHealthKitHeartRateAuthorized {
            Task {
                await viewModel.requestHealthKitAuth()
            }
        } else {
            viewModel.toggleHeartRateMonitoring()
        }
    }
    
    private var cardBackground: some View {
        if !viewModel.isHealthKitHeartRateAuthorized {
            Color.orange.opacity(0.12)
        } else {
            switch viewModel.currentHeartRate {
            case 40...70: Color.green.opacity(0.12)
            case 70...120: Color.yellow.opacity(0.12)
            case 120...160: Color.orange.opacity(0.12)
            default: Color.red.opacity(0.12)
            
            }
        }
    }
    
    private var animatedHeart: some View {
        Image(systemName: isBeating ? "heart.fill" : "heart")
            .font(.system(size: 20))
            .foregroundColor(.red)
            .scaleEffect(isHeartPulsing && isBeating ? 1.15: 1.0)
            .animation(
                isBeating ? .easeInOut(duration: pulseDuration / 2).repeatForever() : .default,
                value: isHeartPulsing
            )
    }
    
    private var heartRateDisplay: some View {
        VStack(alignment: .leading, spacing: 1) {
            if !viewModel.isHealthKitHeartRateAuthorized {
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("--")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    Text("BPM")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                    
                    Text("Tap To Authorize")
                        .font(.system(size: 8))
                        .foregroundColor(.orange)
                }
            } else {
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("\(Int(viewModel.currentHeartRate))")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    Text("BPM")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var statusIndicator: some View {
        Group{
            if !viewModel.isHealthKitHeartRateAuthorized {
                Image(systemName: "exlamationMark.circle.fill")
                    .font(.system(size:14))
                    .foregroundColor(.orange)
            }else if viewModel.isMonitoringHeartRate {
                Image(systemName: "stop.circle.fill")
                    .font(.system(size:14))
                    .foregroundColor(.green)
            }
        }
    }

    var body: some View {
        Button {
            handleTapEvent()
        } label: {
            HStack(spacing: 20) {
                animatedHeart
                
                Spacer()
                // Status Indicator
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(cardBackground)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isBeating {
                isHeartPulsing = true
            }
        }
        .onChange(of: isBeating) { _, newValue in
            if newValue {
                isHeartPulsing = true
            } else {
                isHeartPulsing = false
            }
        }
        .onChange(of: viewModel.currentHeartRate) {
            if isBeating {
                isHeartPulsing = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ){
                    isHeartPulsing = true
                }
            }
        }
    }
}
