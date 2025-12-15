//
//  AppCoordinator.swift
//  Navigation coordinator for the app
//

import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentDestination: Destination = .home
    
    enum Destination: Hashable {
        case home
        case profile
        case friends
        case notifications
        case settings
        case help
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .profile: return "Profile"
            case .friends: return "Friends"
            case .notifications: return "Notifications"
            case .settings: return "Settings"
            case .help: return "Help & Feedback"
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .profile: return "person.fill"
            case .friends: return "person.3.fill"
            case .notifications: return "bell.fill"
            case .settings: return "gear"
            case .help: return "questionmark.circle"
            }
        }
    }
    
    func navigate(to destination: Destination) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentDestination = destination
        }
    }
}

////  AppCoordinator.swift
//import SwiftUI
// import Combine
//
//// MARK: - Navigation Coordinator
//class AppCoordinator: ObservableObject {
//    @Published var currentDestination: Destination = .home
//    @Published var navigationPath = NavigationPath()
//    
//    enum Destination: Hashable {
//        case home
//        case profile
//        case friends
//        case notifications
//        case settings
//        case help
//        
//        var title: String {
//            switch self {
//            case .home: return "Home"
//            case .profile: return "Profile"
//            case .friends: return "Friends"
//            case .notifications: return "Notifications"
//            case .settings: return "Settings"
//            case .help: return "Help"
//            }
//        }
//        
//        var icon: String {
//            switch self {
//            case .home: return "house"
//            case .profile: return "person"
//            case .friends: return "person.3"
//            case .notifications: return "bell"
//            case .settings: return "gear"
//            case .help: return "questionmark.circle"
//            }
//        }
//    }
//    
//    // Navigate to a destination
//    func navigate(to destination: Destination) {
//        currentDestination = destination
//    }
//    
//    // Push a new view onto the navigation stack
//    func push(_ destination: Destination) {
//        navigationPath.append(destination)
//    }
//    
//    // Pop back to previous view
//    func pop() {
//        if !navigationPath.isEmpty {
//            navigationPath.removeLast()
//        }
//    }
//    
//    // Pop to root
//    func popToRoot() {
//        navigationPath = NavigationPath()
//    }
//}
