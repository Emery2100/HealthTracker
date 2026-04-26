//
//  MainDashBoardView.swift
//  HealthTracker
//
//  Created by David Emery on 4/26/26.
//

import SwiftUI

struct MainDashBoardView: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 16){
                Text("Today")
                    .font(.system(size:14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 20){
                VStack{
                    // Water Ring
                    ProgressRingView(
                        color: EntryType.water.color,
                        progress: 0.5,
                        icon: EntryType.water.icon,
                        size: 55
                        )
                    // Todays water intake / Goal <--- Text
                    Text("\(Int(1000))")
                        .font(.system(size:16, weight: .bold, design: .rounded))
                        .foregroundColor(EntryType.water.color)
                    //  water goal
                    Text("\(Int(2000)) ml")
                        .font(.system(size: 9))
                    foregroundColor(.gray)
                }
                
                VStack(spacing: 6){
                    ProgressRingView(
                        color: EntryType.calories.color,
                        progress: 0.5,
                        icon: EntryType.calories.icon,
                        size: 55
                        )
                    // Todays water intake / Goal <--- Text
                    Text("\(Int(1000))")
                        .font(.system(size:16, weight: .bold, design: .rounded))
                        .foregroundColor(EntryType.calories.color)
                    //  water goal
                    Text("\(Int(2000)) ml")
                        .font(.system(size: 9))
                    foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    MainDashBoardView()
}
