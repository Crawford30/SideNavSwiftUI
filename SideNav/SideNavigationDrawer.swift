import SwiftUI

struct SideNavigationDrawer: View {
    @Binding var isShowing: Bool
    @ObservedObject var coordinator: AppCoordinator
    @State private var dragOffset: CGFloat = 0
    
    private let drawerWidth: CGFloat = 280
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Overlay background
            if isShowing {
                Color.black
                    .opacity(calculateOverlayOpacity())
                    .ignoresSafeArea()
                    .onTapGesture {
                        closeDrawer()
                    }
                    .transition(.opacity)
            }
            
            // Drawer content
            if isShowing {
                DrawerContent(
                    coordinator: coordinator,
                    isShowing: $isShowing,
                    dragOffset: dragOffset
                )
                .frame(width: drawerWidth)
                .background(Color(.systemBackground))
                .offset(x: dragOffset)
                .transition(.move(edge: .leading))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Only allow dragging to the left (closing)
                            if value.translation.width < 0 {
                                dragOffset = max(value.translation.width, -drawerWidth)
                            }
                        }
                        .onEnded { value in
                            handleDragEnd(value)
                        }
                )
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowing)
        .onChange(of: isShowing) { oldValue, newValue in
            if newValue {
                dragOffset = 0
            }
        }
    }
    
    private func closeDrawer() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isShowing = false
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        let threshold: CGFloat = -drawerWidth / 3
        let velocity = value.predictedEndTranslation.width
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            if value.translation.width < threshold || velocity < -500 {
                isShowing = false
            }
            dragOffset = 0
        }
    }
    
    private func calculateOverlayOpacity() -> Double {
        if dragOffset < 0 {
            let dragPercentage = abs(dragOffset) / drawerWidth
            return 0.5 * (1 - dragPercentage)
        }
        return 0.5
    }
}

// MARK: - Drawer Content
struct DrawerContent: View {
    @ObservedObject var coordinator: AppCoordinator
    @Binding var isShowing: Bool
    let dragOffset: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            DrawerHeader()
            
            Divider()
            
            // Navigation Items
            ScrollView {
                VStack(spacing: 0) {
                    DrawerSection(title: "Main") {
                        DrawerItem(
                            destination: .home,
                            coordinator: coordinator,
                            isShowing: $isShowing
                        )
                        
                        DrawerItem(
                            destination: .profile,
                            coordinator: coordinator,
                            isShowing: $isShowing
                        )
                    }
                    
                    DrawerSection(title: "Social") {
                        DrawerItem(
                            destination: .friends,
                            coordinator: coordinator,
                            isShowing: $isShowing
                        )
                        
                        DrawerItem(
                            destination: .notifications,
                            coordinator: coordinator,
                            isShowing: $isShowing,
                            badge: 5
                        )
                    }
                    
                    DrawerSection(title: "Settings") {
                        DrawerItem(
                            destination: .settings,
                            coordinator: coordinator,
                            isShowing: $isShowing
                        )
                    }
                }
            }
            
            Spacer()
            
            // Footer
            DrawerFooter(
                coordinator: coordinator,
                isShowing: $isShowing
            )
        }
    }
}

// MARK: - Drawer Header
struct DrawerHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Button {
                    // Edit profile action
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("John Doe")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("john.doe@example.com")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
    }
}

// MARK: - Drawer Section
struct DrawerSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 4)
            }
            
            content
            
            Divider()
                .padding(.vertical, 8)
        }
    }
}

// MARK: - Drawer Item
struct DrawerItem: View {
    let destination: AppCoordinator.Destination
    @ObservedObject var coordinator: AppCoordinator
    @Binding var isShowing: Bool
    var badge: Int? = nil
    
    private var isSelected: Bool {
        coordinator.currentDestination == destination
    }
    
    var body: some View {
        Button {
            handleTap()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: destination.icon)
                    .font(.system(size: 20))
                    .frame(width: 24)
                    .foregroundStyle(isSelected ? .blue : .primary)
                
                Text(destination.title)
                    .font(.body)
                    .foregroundStyle(isSelected ? .blue : .primary)
                
                Spacer()
                
                if let badge = badge, badge > 0 {
                    BadgeView(count: badge)
                }
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 8)
    }
    
    private func handleTap() {
        coordinator.navigate(to: destination)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isShowing = false
        }
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: - Badge View
struct BadgeView: View {
    let count: Int
    
    var body: some View {
        Text("\(count)")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.red)
            )
    }
}

// MARK: - Drawer Footer
struct DrawerFooter: View {
    @ObservedObject var coordinator: AppCoordinator
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            Button {
                coordinator.navigate(to: .help)
                withAnimation {
                    isShowing = false
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 20))
                    
                    Text("Help & Feedback")
                        .font(.body)
                    
                    Spacer()
                }
                .foregroundStyle(.primary)
                .padding()
            }
            
            Button {
                // Logout action
                withAnimation {
                    isShowing = false
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 20))
                    
                    Text("Logout")
                        .font(.body)
                    
                    Spacer()
                }
                .foregroundStyle(.red)
                .padding()
            }
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    SideNavigationDrawer(
        isShowing: .constant(true),
        coordinator: AppCoordinator()
    )
}
