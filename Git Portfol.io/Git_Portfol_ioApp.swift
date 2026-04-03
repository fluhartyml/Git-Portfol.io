//
//  Git_Portfol_ioApp.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import SwiftUI
import SwiftData

@main
struct Git_Portfol_ioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: RepoSettings.self)
        .defaultSize(width: 1200, height: 800)
    }
}
