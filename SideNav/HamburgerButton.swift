import SwiftUI

struct HamburgerButton: View {
    let action: () -> Void
    
    // Customization
    var lineWidth: CGFloat = 2.5
    var lineLength: CGFloat = 20
    var lineSpacing: CGFloat = 6
    var color: Color = .primary
    
    var body: some View {
        Button(action: action) {
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                
                // Top line
                drawLine(
                    context: context,
                    center: center,
                    yOffset: -lineSpacing
                )
                
                // Middle line
                drawLine(
                    context: context,
                    center: center,
                    yOffset: 0
                )
                
                // Bottom line
                drawLine(
                    context: context,
                    center: center,
                    yOffset: lineSpacing
                )
            }
            .frame(width: 32, height: 32)
            .contentShape(Rectangle())
        }
        .buttonStyle(HamburgerButtonStyle())
    }
    
    private func drawLine(
        context: GraphicsContext,
        center: CGPoint,
        yOffset: CGFloat
    ) {
        let start = CGPoint(
            x: center.x - lineLength / 2,
            y: center.y + yOffset
        )
        let end = CGPoint(
            x: center.x + lineLength / 2,
            y: center.y + yOffset
        )
        
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        
        context.stroke(
            path,
            with: .color(color),
            lineWidth: lineWidth
        )
    }
}

// Custom button style for haptic feedback
struct HamburgerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                if newValue {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}

// MARK: - Alternative Implementation with SF Symbols

/// Simple hamburger button using SF Symbol (stays as hamburger)
struct HamburgerButtonSimple: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "line.3.horizontal")
                .font(.title3)
                .foregroundStyle(.primary)
        }
        .buttonStyle(HamburgerButtonStyle())
    }
}

// MARK: - Material Design Style (Static)

/// Material Design hamburger button (no transformation)
struct HamburgerButtonMaterial: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.primary)
                    .frame(width: 22, height: 2.5)
                
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.primary)
                    .frame(width: 22, height: 2.5)
                
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.primary)
                    .frame(width: 22, height: 2.5)
            }
            .frame(width: 32, height: 32)
            .contentShape(Rectangle())
        }
        .buttonStyle(HamburgerButtonStyle())
    }
}

// MARK: - Previews

#Preview("Standard Hamburger") {
    VStack(spacing: 40) {
        Text("Custom Canvas Button")
            .font(.headline)
        HamburgerButton {}
        
        Divider()
        
        Text("Simple SF Symbol Button")
            .font(.headline)
        HamburgerButtonSimple {}
        
        Divider()
        
        Text("Material Design Button")
            .font(.headline)
        HamburgerButtonMaterial {}
    }
    .padding()
}

#Preview("Interactive Example") {
    StatefulHamburgerPreview()
        .padding()
}

// Helper view for interactive preview
struct StatefulHamburgerPreview: View {
    @State private var drawerOpen = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text(drawerOpen ? "Drawer Open" : "Drawer Closed")
                .font(.headline)
                .foregroundStyle(drawerOpen ? .green : .secondary)
            
            HamburgerButtonMaterial {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    drawerOpen.toggle()
                }
            }
            
            Text("Tap to toggle")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

