//
//  ContentView.swift
//  PumpIn
//
//  Created by Yoel Toledo on 14/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("PumpIn")
                .font(.title)
            
            #if DEBUG
            VStack(alignment: .leading, spacing: 10) {
                Text("Environment: \(BuildConfig.environment)")
                Text("Base URL: \(BuildConfig.baseURL)")
                Text("Is Debug: \(BuildConfig.isDebug ? "Yes" : "No")")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            #endif
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
