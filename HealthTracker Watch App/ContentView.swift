//
//  ContentView.swift
//  HealthTracker Watch App
//
//  Created by David Emery on 4/26/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HealthViewModel()
    
    var body: some View {
        NavigationStack {
            MainDashboardView(viewModel: viewModel)
        }.onAppear {
            viewModel.refreshTodaysData()
        }
    }
}

#Preview {
    ContentView()
}
