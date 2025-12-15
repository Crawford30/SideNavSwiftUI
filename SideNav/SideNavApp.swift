//
//  SideNavApp.swift
//  Main app entry point
//

import SwiftUI

@main
struct SideNavApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorRootView()
                .environmentObject(coordinator)
        }
    }
}
