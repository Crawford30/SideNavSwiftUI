import SwiftUI

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Here's what's happening today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Actions")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        QuickActionCard(
                            icon: "person.3",
                            title: "Friends",
                            color: .green
                        ) {
                            coordinator.navigate(to: .friends)
                        }
                        
                        QuickActionCard(
                            icon: "bell",
                            title: "Notifications",
                            color: .orange,
                            badge: 5
                        ) {
                            coordinator.navigate(to: .notifications)
                        }
                        
                        QuickActionCard(
                            icon: "person",
                            title: "Profile",
                            color: .blue
                        ) {
                            coordinator.navigate(to: .profile)
                        }
                        
                        QuickActionCard(
                            icon: "gear",
                            title: "Settings",
                            color: .gray
                        ) {
                            coordinator.navigate(to: .settings)
                        }
                    }
                }
                .padding()
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.headline)
                    
                    ForEach(1...5, id: \.self) { index in
                        ActivityRow(
                            title: "Activity \(index)",
                            subtitle: "Just now",
                            icon: "circle.fill"
                        )
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(.blue)
                    
                    VStack(spacing: 4) {
                        Text("John Doe")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("iOS Developer")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Button("Edit Profile") {
                        // Edit profile action
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Profile Stats
                HStack(spacing: 0) {
                    ProfileStat(title: "Posts", value: "127")
                    Divider()
                    ProfileStat(title: "Friends", value: "543")
                    Divider()
                    ProfileStat(title: "Likes", value: "1.2K")
                }
                .frame(height: 80)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Profile Sections
                VStack(alignment: .leading, spacing: 16) {
                    ProfileSection(icon: "envelope", title: "Email", value: "john.doe@example.com")
                    ProfileSection(icon: "phone", title: "Phone", value: "+1 (555) 123-4567")
                    ProfileSection(icon: "mappin", title: "Location", value: "San Francisco, CA")
                    ProfileSection(icon: "calendar", title: "Joined", value: "January 2024")
                }
            }
            .padding()
        }
    }
}

// MARK: - Friends View
struct FriendsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search friends", text: $searchText)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            
            // Friends List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(1...20, id: \.self) { index in
                        FriendRow(
                            name: "Friend \(index)",
                            status: index % 2 == 0 ? "Online" : "Offline",
                            isOnline: index % 2 == 0
                        )
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Notifications View
struct NotificationsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(1...15, id: \.self) { index in
                    NotificationRow(
                        title: "Notification \(index)",
                        subtitle: "\(index) minutes ago",
                        isUnread: index <= 5
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        Form {
            Section("Preferences") {
                Toggle("Push Notifications", isOn: $notificationsEnabled)
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
            
            Section("Account") {
                Button("Edit Profile") {
                    coordinator.navigate(to: .profile)
                }
                Button("Privacy Settings") {
                    // Privacy settings
                }
                Button("Security") {
                    // Security settings
                }
            }
            
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }
                Button("Terms of Service") {
                    // Terms
                }
                Button("Privacy Policy") {
                    // Privacy
                }
            }
            
            Section {
                Button("Logout", role: .destructive) {
                    // Logout
                }
            }
        }
    }
}

// MARK: - Help View
struct HelpView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        List {
            Section("Support") {
                Button {
                    // FAQ action
                } label: {
                    Label("FAQ", systemImage: "questionmark.circle")
                }
                
                Button {
                    // Contact action
                } label: {
                    Label("Contact Support", systemImage: "envelope")
                }
                
                Button {
                    // Tutorial action
                } label: {
                    Label("App Tutorial", systemImage: "book")
                }
            }
            
            Section("Feedback") {
                Button {
                    // Report bug
                } label: {
                    Label("Report a Bug", systemImage: "ant")
                }
                
                Button {
                    // Feature request
                } label: {
                    Label("Request a Feature", systemImage: "lightbulb")
                }
            }
        }
    }
}

// MARK: - Supporting Components

struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    var badge: Int? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: icon)
                        .font(.system(size: 32))
                        .foregroundStyle(color)
                    
                    if let badge = badge, badge > 0 {
                        Text("\(badge)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .offset(x: 8, y: -8)
                    }
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ProfileStat: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileSection: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct FriendRow: View {
    let name: String
    let status: String
    let isOnline: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                
                Circle()
                    .fill(isOnline ? Color.green : Color.gray)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 2)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                
                Text(status)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                // Message action
            } label: {
                Image(systemName: "message.fill")
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct NotificationRow: View {
    let title: String
    let subtitle: String
    let isUnread: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bell.fill")
                .font(.title3)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isUnread ? .semibold : .regular)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if isUnread {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .background(isUnread ? Color.blue.opacity(0.05) : Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
