import SwiftUI

// MARK: - Root View
struct CoordinatorRootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var isShowingSideNav = false
    
    var body: some View {
        ZStack {
            // Main content area with custom navigation bar
            VStack(spacing: 0) {
                // Custom Navigation Bar
                CustomNavigationBar(
                    title: coordinator.currentDestination.title,
                    onMenuTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isShowingSideNav.toggle()
                        }
                    }
                )
                
                // Content area
                destinationView(for: coordinator.currentDestination)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .zIndex(0)
            
            // Side navigation drawer
            SideNavigationDrawer(
                isShowing: $isShowingSideNav,
                coordinator: coordinator
            )
            .zIndex(1)
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onEnded { value in
                    // Swipe from left edge to open drawer
                    if value.startLocation.x < 20 && value.translation.width > 50 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isShowingSideNav = true
                        }
                    }
                }
        )
    }
    
    @ViewBuilder
    private func destinationView(for destination: AppCoordinator.Destination) -> some View {
        switch destination {
        case .home:
            HomeView()
        case .profile:
            ProfileView()
        case .friends:
            FriendsView()
        case .notifications:
            NotificationsView()
        case .settings:
            SettingsView()
        case .help:
            HelpView()
        }
    }
}

// MARK: - Custom Navigation Bar
struct CustomNavigationBar: View {
    let title: String
    let onMenuTap: () -> Void
    
    var body: some View {
        HStack {
            // Hamburger button
            HamburgerButtonMaterial(action: onMenuTap)
                .frame(width: 44, height: 44)
            
            Spacer()
            
            // Title
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Trailing button
            Button {
                // Additional actions
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
            .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color(.systemBackground))
        .overlay(
            Divider()
                .frame(maxWidth: .infinity, maxHeight: 0.5)
                .background(Color(.separator)),
            alignment: .bottom
        )
    }
}

#Preview {
    CoordinatorRootView()
        .environmentObject(AppCoordinator())
}


////
////  CoordinatorRootView.swift
////  Main navigation container with drawer
////
//
//import SwiftUI
//
//// MARK: - Root View
//struct CoordinatorRootView: View {
//    @EnvironmentObject var coordinator: AppCoordinator
//    @State private var isShowingSideNav = false
//    
//    var body: some View {
//        ZStack {
//            // Main content area - switches based on current destination
//            NavigationStack {
//                destinationView(for: coordinator.currentDestination)
//                    .navigationBarTitleDisplayMode(.inline)
//                    .toolbar {
//                        ToolbarItem(placement: .topBarLeading) {
//                            HamburgerButtonMaterial {
//                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                    isShowingSideNav.toggle()
//                                }
//                            }
//                        }
//                        
//                        ToolbarItem(placement: .topBarTrailing) {
//                            Button {
//                                // Additional actions
//                            } label: {
//                                Image(systemName: "ellipsis.circle")
//                                    .font(.title3)
//                                    .foregroundStyle(.primary)
//                            }
//                        }
//                    }
//            }
//            .zIndex(0)
//            
//            // Side navigation drawer
//            SideNavigationDrawer(
//                isShowing: $isShowingSideNav,
//                coordinator: coordinator
//            )
//            .zIndex(1)
//        }
//        .gesture(
//            DragGesture(minimumDistance: 0, coordinateSpace: .global)
//                .onEnded { value in
//                    // Swipe from left edge to open drawer
//                    if value.startLocation.x < 20 && value.translation.width > 50 {
//                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                            isShowingSideNav = true
//                        }
//                    }
//                }
//        )
//    }
//    
//    @ViewBuilder
//    private func destinationView(for destination: AppCoordinator.Destination) -> some View {
//        switch destination {
//        case .home:
//            HomeView()
//        case .profile:
//            ProfileView()
//        case .friends:
//            FriendsView()
//        case .notifications:
//            NotificationsView()
//        case .settings:
//            SettingsView()
//        case .help:
//            HelpView()
//        }
//    }
//}
//
//#Preview {
//    CoordinatorRootView()
//        .environmentObject(AppCoordinator())
//}



////
////  CoordinatorRootView.swift
////  Main navigation container with drawer
////
//
//import SwiftUI
//
//// MARK: - Root View
//struct CoordinatorRootView: View {
//    @EnvironmentObject var coordinator: AppCoordinator
//    @State private var isShowingSideNav = false
//    
//    var body: some View {
//        ZStack {
//            NavigationStack(path: $coordinator.navigationPath) {
//                destinationView(for: coordinator.currentDestination)
//                    .navigationBarTitleDisplayMode(.inline)
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            HamburgerButtonMaterial {
//                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                    isShowingSideNav.toggle()
//                                }
//                            }
//                            .disabled(false) // Always enabled
//                            .opacity(1.0) // Always fully visible
//                        }
//                        
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            Button {
//                                // Additional actions
//                            } label: {
//                                Image(systemName: "ellipsis.circle")
//                                    .font(.title3)
//                                    .foregroundStyle(.primary)
//                            }
//                        }
//                    }
//                    .navigationDestination(for: AppCoordinator.Destination.self) { destination in
//                        destinationView(for: destination)
//                            .toolbar {
//                                // Ensure hamburger button appears on all pages
//                                ToolbarItem(placement: .navigationBarLeading) {
//                                    HamburgerButtonMaterial {
//                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                            isShowingSideNav.toggle()
//                                        }
//                                    }
//                                }
//                            }
//                    }
//            }
//            .zIndex(0)
//            
//            SideNavigationDrawer(
//                isShowing: $isShowingSideNav,
//                coordinator: coordinator
//            )
//            .zIndex(1)
//        }
//        .gesture(
//            DragGesture(minimumDistance: 0, coordinateSpace: .global)
//                .onEnded { value in
//                    // Swipe from left edge to open drawer
//                    if value.startLocation.x < 20 && value.translation.width > 50 {
//                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                            isShowingSideNav = true
//                        }
//                    }
//                }
//        )
//    }
//    
//    @ViewBuilder
//    private func destinationView(for destination: AppCoordinator.Destination) -> some View {
//        switch destination {
//        case .home:
//            HomeView()
//        case .profile:
//            ProfileView()
//        case .friends:
//            FriendsView()
//        case .notifications:
//            NotificationsView()
//        case .settings:
//            SettingsView()
//        case .help:
//            HelpView()
//        }
//    }
//}
//
//#Preview {
//    CoordinatorRootView()
//        .environmentObject(AppCoordinator())
//}
//
//////
//////  CoordinatorRootView.swift
//////  Main navigation container with drawer
//////
////
////import SwiftUI
////
////// MARK: - Root View
////struct CoordinatorRootView: View {
////    @EnvironmentObject var coordinator: AppCoordinator
////    @State private var isShowingSideNav = false
////    
////    var body: some View {
////        ZStack {
////            NavigationStack(path: $coordinator.navigationPath) {
////                destinationView(for: coordinator.currentDestination)
////                    .navigationBarTitleDisplayMode(.inline)
////                    .toolbar {
////                        ToolbarItem(placement: .navigationBarLeading) {
////                            HamburgerButtonMaterial {
////                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
////                                    isShowingSideNav.toggle()
////                                }
////                            }
////                        }
////                        
////                        ToolbarItem(placement: .navigationBarTrailing) {
////                            Button {
////                                // Additional actions
////                            } label: {
////                                Image(systemName: "ellipsis.circle")
////                                    .font(.title3)
////                                    .foregroundStyle(.primary)
////                            }
////                        }
////                    }
////                    .navigationDestination(for: AppCoordinator.Destination.self) { destination in
////                        destinationView(for: destination)
////                    }
////            }
////            
////            SideNavigationDrawer(
////                isShowing: $isShowingSideNav,
////                coordinator: coordinator
////            )
////        }
////        .gesture(
////            DragGesture(minimumDistance: 0, coordinateSpace: .global)
////                .onEnded { value in
////                    // Swipe from left edge to open drawer
////                    if value.startLocation.x < 20 && value.translation.width > 50 {
////                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
////                            isShowingSideNav = true
////                        }
////                    }
////                }
////        )
////    }
////    
////    @ViewBuilder
////    private func destinationView(for destination: AppCoordinator.Destination) -> some View {
////        switch destination {
////        case .home:
////            HomeView()
////        case .profile:
////            ProfileView()
////        case .friends:
////            FriendsView()
////        case .notifications:
////            NotificationsView()
////        case .settings:
////            SettingsView()
////        case .help:
////            HelpView()
////        }
////    }
////}
////
////#Preview {
////    CoordinatorRootView()
////        .environmentObject(AppCoordinator())
////}
////
////////
////////  CoordinatorRootView.swift
////////  Main navigation container with drawer
////////
//////
//////import SwiftUI
//////
//////// MARK: - Root View
//////struct CoordinatorRootView: View {
//////    @EnvironmentObject var coordinator: AppCoordinator
//////    @State private var isShowingSideNav = false
//////    
//////    var body: some View {
//////        ZStack {
//////            NavigationStack(path: $coordinator.navigationPath) {
//////                destinationView(for: coordinator.currentDestination)
//////                    .navigationBarTitleDisplayMode(.inline)
//////                    .toolbar {
//////                        ToolbarItem(placement: .navigationBarLeading) {
//////                            HamburgerButtonMaterial(isOpen: $isShowingSideNav) {
//////                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//////                                    isShowingSideNav.toggle()
//////                                }
//////                            }
//////                        }
//////                        
//////                        ToolbarItem(placement: .navigationBarTrailing) {
//////                            Button {
//////                                // Additional actions
//////                            } label: {
//////                                Image(systemName: "ellipsis.circle")
//////                                    .font(.title3)
//////                                    .foregroundStyle(.primary)
//////                            }
//////                        }
//////                    }
//////                    .navigationDestination(for: AppCoordinator.Destination.self) { destination in
//////                        destinationView(for: destination)
//////                    }
//////            }
//////            
//////            SideNavigationDrawer(
//////                isShowing: $isShowingSideNav,
//////                coordinator: coordinator
//////            )
//////        }
//////        .gesture(
//////            DragGesture(minimumDistance: 0, coordinateSpace: .global)
//////                .onEnded { value in
//////                    // Swipe from left edge to open drawer
//////                    if value.startLocation.x < 20 && value.translation.width > 50 {
//////                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//////                            isShowingSideNav = true
//////                        }
//////                    }
//////                }
//////        )
//////    }
//////    
//////    @ViewBuilder
//////    private func destinationView(for destination: AppCoordinator.Destination) -> some View {
//////        switch destination {
//////        case .home:
//////            HomeView()
//////        case .profile:
//////            ProfileView()
//////        case .friends:
//////            FriendsView()
//////        case .notifications:
//////            NotificationsView()
//////        case .settings:
//////            SettingsView()
//////        case .help:
//////            HelpView()
//////        }
//////    }
//////}
//////
//////#Preview {
//////    CoordinatorRootView()
//////        .environmentObject(AppCoordinator())
//////}
