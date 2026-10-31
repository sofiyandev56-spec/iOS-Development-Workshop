import SwiftUI
import Combine

/// Main Content View of SwiftArcade Duo
public struct ContentView: View {
    @ObservedObject var foldableManager = FoldableDeviceManager.shared
    @ObservedObject var profile = ArcadeProfileManager.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            // Core Foldable Dual-Screen Layout
            if foldableManager.currentPosture == .closedCover {
                iPhone18ProMaxCoverView()
            } else {
                DuoFoldableContainerView {
                    // Left Screen: Main Arcade Hub
                    ArcadeHomeView()
                } rightContent: {
                    // Right Screen: Neural Assistant & Telemetry Dashboard
                    rightCompanionDashboard
                }
            }
            
            // Bottom Floating Hinge Simulator & Posture Bar
            VStack {
                Spacer()
                InteractiveHingeSimulatorBar()
                    .padding(.bottom, 6)
            }
        }
    }
    
    // MARK: - Right Companion Dashboard (Active in Dual-Screen iPhone Duo mode)
    private var rightCompanionDashboard: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Label("RIGHT SCREEN • NEURAL COMPANION", systemImage: "brain.head.profile")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(ArcadeTheme.neuralViolet)
                    Spacer()
                    Text("38 TOPS ANE ACTIVE")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(ArcadeTheme.siliconGreen)
                }
                
                // Live Device Hardware Telemetry Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("iPhone Duo Sensor Array")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 12) {
                        telemetryPill(title: "Hinge Angle", value: "\(Int(foldableManager.hingeAngle))°", icon: "angle")
                        telemetryPill(title: "Crease Width", value: String(format: "%.1f pt", foldableManager.creaseWidth), icon: "arrow.left.and.right")
                        telemetryPill(title: "Displays", value: "2x 120Hz", icon: "sparkles.tv")
                    }
                }
                .padding()
                .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.neuralViolet)
                
                // Embedded Ada Neural Tutor Quick Stream
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(ArcadeTheme.cupertinoCyan)
                        Text("Ada's Live Study Feed")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                    }
                    
                    Text("Ready for your next challenge! Launch 'Hinge Hack' to experience continuous thread routing across the fold crease.")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.85))
                    
                    Text("// Swift 6 Tip: Prefer @Observable over ObservableObject for granular view invalidation.")
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(ArcadeTheme.siliconGreen)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
                .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.cupertinoCyan)
                
                // Apple Engineering Trophy Preview
                VStack(alignment: .leading, spacing: 10) {
                    Text("Honors & Badges")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 10) {
                        ForEach(profile.trophies.prefix(3)) { trophy in
                            VStack(spacing: 6) {
                                Image(systemName: trophy.iconName)
                                    .font(.title2)
                                    .foregroundStyle(trophy.accentColor)
                                Text(trophy.title)
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .liquidGlassCard(cornerRadius: 12, tint: trophy.accentColor)
                        }
                    }
                }
                .padding()
                .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.liquidGold)
                
                Color.clear.frame(height: 70)
            }
            .padding()
        }
    }
    
    private func telemetryPill(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(ArcadeTheme.cupertinoCyan)
            Text(value)
                .font(.system(.caption, design: .monospaced, weight: .bold))
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 8))
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
}

