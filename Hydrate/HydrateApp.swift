//
//  HydrateApp.swift
//  Hydrate
//
//  Created by Raghad on 17/10/2024.
//

import SwiftUI

@main
struct HydrateApp: App {
    
    @StateObject private var userDefaultsVM = UserDefaultViewModel()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                
            }
        .environmentObject(userDefaultsVM)
        }
    }

