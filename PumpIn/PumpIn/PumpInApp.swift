//
//  PumpInApp.swift
//  PumpIn
//
//  Created by Yoel Toledo on 14/04/2025.
//

import SwiftUI

@main
struct PumpInApp: App {
    init() {
        #if DEBUG
        DevDataReset.resetAll()
        #endif
    }
    var body: some Scene {
        WindowGroup {
            WorkoutListView()
        }
    }
}
