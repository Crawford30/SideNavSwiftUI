//  SideNavView.swift
import SwiftUI

struct SideNavView: View {
    @Binding var isShowingSideNav: Bool
    @State private var dragOffset: CGFloat = 0
    
    // Width of the side navigation drawer
    private let sideNavWidth: CGFloat = 280
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Dimmed background overlay
            if isShowingSideNav {
                Color.black
                    .opacity(overlayOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowingSideNav = false
                        }
                    }
                    .transition(.opacity)
            }
            
            // Side navigation drawer
            if isShowingSideNav {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header section
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 64))
                                .foregroundStyle(.blue)
                            
                            Text("John Doe")
                                .font(.headline)
                            
                            Text("john.doe@example.com")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        
                        Divider()
                        
                        // Navigation content
                        ScrollView {
                            SideNavContent(isShowingSideNav: $isShowingSideNav)
                        }
                        
                        Spacer()
                        
                        // Footer section
                        Divider()
                        
                        VStack(spacing: 0) {
                            Button {
                                withAnimation {
                                    isShowingSideNav = false
                                }
                                // Handle help action
                            } label: {
                                Label("Help & Feedback", systemImage: "questionmark.circle")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                            
                            Button {
                                withAnimation {
                                    isShowingSideNav = false
                                }
                                // Handle logout action
                            } label: {
                                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                        }
                    }
                    .frame(width: sideNavWidth)
                    .background(Color(.systemBackground))
                    .offset(x: dragOffset)
                    
                    Spacer(minLength: 0)
                }
                .transition(.move(edge: .leading))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Only allow dragging to the left (closing)
                            if value.translation.width < 0 {
                                dragOffset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            let threshold: CGFloat = -sideNavWidth / 3
                            
                            withAnimation(.easeOut(duration: 0.2)) {
                                if value.translation.width < threshold || value.predictedEndTranslation.width < threshold * 2 {
                                    // Close the drawer
                                    isShowingSideNav = false
                                }
                                dragOffset = 0
                            }
                        }
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowingSideNav)
        .toolbar(isShowingSideNav ? .hidden : .visible, for: .navigationBar)
        .onChange(of: isShowingSideNav) { oldValue, newValue in
            if newValue {
                dragOffset = 0
            }
        }
    }
    
    // Calculate overlay opacity based on drag offset
    private var overlayOpacity: Double {
        if dragOffset < 0 {
            let dragPercentage = abs(dragOffset) / sideNavWidth
            return 0.5 * (1 - dragPercentage)
        }
        return 0.5
    }
}

#Preview {
    SideNavView(isShowingSideNav: .constant(true))
}


struct SideNavContent: View {
    @Binding var isShowingSideNav: Bool
    @State private var selectedItem: String? = "Home"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavItem(
                title: "Home",
                icon: "house",
                isSelected: selectedItem == "Home"
            ) {
                selectedItem = "Home"
                withAnimation {
                    isShowingSideNav = false
                }
            }
            
            NavItem(
                title: "Profile",
                icon: "person",
                isSelected: selectedItem == "Profile"
            ) {
                selectedItem = "Profile"
                withAnimation {
                    isShowingSideNav = false
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            NavItem(
                title: "Friends",
                icon: "person.3",
                isSelected: selectedItem == "Friends"
            ) {
                selectedItem = "Friends"
                withAnimation {
                    isShowingSideNav = false
                }
            }
            
            NavItem(
                title: "Notifications",
                icon: "bell",
                isSelected: selectedItem == "Notifications",
                badge: 5
            ) {
                selectedItem = "Notifications"
                withAnimation {
                    isShowingSideNav = false
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            NavItem(
                title: "Settings",
                icon: "gear",
                isSelected: selectedItem == "Settings"
            ) {
                selectedItem = "Settings"
                withAnimation {
                    isShowingSideNav = false
                }
            }
            
            NavItem(
                title: "Share",
                icon: "square.and.arrow.up",
                isSelected: selectedItem == "Share"
            ) {
                selectedItem = "Share"
                withAnimation {
                    isShowingSideNav = false
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// Reusable navigation item component
struct NavItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    var badge: Int? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 24)
                    .foregroundStyle(isSelected ? .blue : .primary)
                
                Text(title)
                    .font(.body)
                    .foregroundStyle(isSelected ? .blue : .primary)
                
                Spacer()
                
                if let badge = badge, badge > 0 {
                    Text("\(badge)")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
