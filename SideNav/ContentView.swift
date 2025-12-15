import SwiftUI

struct ContentView: View {
    @State private var isShowingSideNav = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Button("Toggle side nav") {
                        withAnimation {
                            isShowingSideNav.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    Text("Swipe from left edge to open")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .padding()
                .navigationTitle("Content View")
            }
            
            SideNavView(isShowingSideNav: $isShowingSideNav)
        }
        // Add gesture to open side nav from left edge
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    // Detect swipe from left edge
                    if value.startLocation.x < 20 && value.translation.width > 50 {
                        withAnimation {
                            isShowingSideNav = true
                        }
                    }
                }
        )
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  SideNav
//
//  Created by Joel Crawford on 15/12/2025.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}


