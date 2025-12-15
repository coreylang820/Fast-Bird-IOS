//
//  Fast_BirdApp.swift
//  Fast Bird
//
//  Created by User You on 11/27/25.
//

import SwiftUI
import SwiftData

@main
struct Fast_BirdApp: App {
    @StateObject private var settings = SettingsManager.shared
    @State private var showLoading = true
    @State private var showPrivacy = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GameStatistics.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLoading {
                    SplashView(onComplete: {
                        showLoading = false
                        if !settings.isPrivacyAccepted {
                            showPrivacy = true
                        }
                    })
                } else if showPrivacy {
                    PrivacyView(mode: .accept, onAccept: {
                        showPrivacy = false
                    })
                } else {
                    HomeView()
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
