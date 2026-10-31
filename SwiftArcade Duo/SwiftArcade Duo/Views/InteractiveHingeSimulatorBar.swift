import SwiftUI
import Combine

/// Floating Interactive Hinge Simulator & Posture Controller
/// Allows testing iPhone Duo folding and unfolding in real time on any screen!
public struct InteractiveHingeSimulatorBar: View {
    @ObservedObject var foldableManager = FoldableDeviceManager.shared
    @State private var isExpanded: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 8) {
            // Main Floating Pill
            HStack(spacing: 12) {
                // Posture Icon & Degree
                HStack(spacing: 6) {
                    Image(systemName: foldableManager.currentPosture.iconName)
                        .foregroundStyle(ArcadeTheme.swiftOrange)
                        .font(.subheadline)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(foldableManager.deviceType == .iphoneDuo ? "iPhone Duo" : "iPhone 18 Pro Max")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                        Text("\(Int(foldableManager.hingeAngle))° • \(foldableManager.currentPosture.rawValue)")
                            .font(.system(size: 9))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Quick Toggle Posture Buttons
                HStack(spacing: 6) {
                    Button {
                        foldableManager.setPosture(.unfoldedFlat)
                    } label: {
                        Image(systemName: "rectangle.split.2x1.fill")
                            .font(.caption2)
                            .padding(6)
                            .background(foldableManager.currentPosture == .unfoldedFlat ? ArcadeTheme.arcadeCrimson : Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button {
                        foldableManager.setPosture(.book)
                    } label: {
                        Image(systemName: "book.closed.fill")
                            .font(.caption2)
                            .padding(6)
                            .background(foldableManager.currentPosture == .book ? ArcadeTheme.cupertinoCyan : Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button {
                        foldableManager.setPosture(.tabletop)
                    } label: {
                        Image(systemName: "laptopcomputer")
                            .font(.caption2)
                            .padding(6)
                            .background(foldableManager.currentPosture == .tabletop ? ArcadeTheme.neuralViolet : Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button {
                        foldableManager.setPosture(.closedCover)
                    } label: {
                        Image(systemName: "iphone")
                            .font(.caption2)
                            .padding(6)
                            .background(foldableManager.currentPosture == .closedCover ? ArcadeTheme.siliconGreen : Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                
                // Expand / Collapse Chevron
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        isExpanded.toggle()
                    }
                    SoundEngine.shared.playTap()
                } label: {
                    Image(systemName: isExpanded ? "chevron.down.circle.fill" : "slider.horizontal.3")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .liquidGlassCard(cornerRadius: 24, tint: ArcadeTheme.swiftOrange, strokeOpacity: 0.45)
            
            // Expanded Precision Hinge Slider & Telemetry
            if isExpanded {
                VStack(spacing: 10) {
                    // Precision Hinge Angle Slider
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Real-Time Hinge Fold Scrubbing")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(ArcadeTheme.swiftOrange)
                            Spacer()
                            Text("\(Int(foldableManager.hingeAngle))°")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(.white)
                        }
                        
                        Slider(value: $foldableManager.hingeAngle, in: 0...180, step: 1.0)
                            .tint(ArcadeTheme.arcadeGradient)
                    }
                    
                    // Device Switcher
                    HStack {
                        Text("Target Device Simulation:")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.7))
                        Spacer()
                        Picker("Device", selection: $foldableManager.deviceType) {
                            Text("iPhone Duo").tag(TargetDeviceType.iphoneDuo)
                            Text("iPhone 18 Pro Max").tag(TargetDeviceType.iphone18ProMax)
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 200)
                    }
                    
                    // Posture Description
                    Text(foldableManager.currentPosture.description)
                        .font(.system(size: 10))
                        .foregroundStyle(.white.opacity(0.65))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(14)
                .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.swiftOrange)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}

