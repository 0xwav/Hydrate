//
//  HydrateApp.swift
//  Hydrate
//
//  Created by Raghad on 17/10/2024.
//

import SwiftUI

@main
struct HydrateApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    var body: some Scene {
        WindowGroup {
            DashboardView()
                
            }
        }
    }

