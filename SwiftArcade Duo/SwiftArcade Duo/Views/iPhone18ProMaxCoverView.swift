import SwiftUI
import Combine

/// Specialized UI for iPhone 18 Pro Max and iPhone Duo Cover Display
public struct iPhone18ProMaxCoverView: View {
    @ObservedObject var profile = ArcadeProfileManager.shared
    @ObservedObject var foldableManager = FoldableDeviceManager.shared
    
    @State private var activeSheet: ActiveArcadeSheet? = nil
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Dynamic Island 3.0 Live Activity Pill
                dynamicIslandActivityPill
                
                // Cover Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("COVER MODE")
                            .font(.system(size: 9, weight: .black, design: .monospaced))
                            .foregroundStyle(ArcadeTheme.siliconGreen)
                        Text("iPhone 18 Pro Max")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Button {
                        foldableManager.setPosture(.unfoldedFlat)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "rectangle.split.2x1.fill")
                            Text("Unfold to Duo")
                                .font(.caption.bold())
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(ArcadeTheme.arcadeCrimson)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                
                // One-Handed Quick Launch Carousel
                ScrollView {
                    VStack(spacing: 14) {
                        // Fast Play Cards
                        coverActionCard(
                            title: "Swift Syntax Blitz",
                            subtitle: "15s Speedrun • ARC & Concurrency",
                            icon: "bolt.fill",
                            tint: ArcadeTheme.arcadeCrimson,
                            sheet: .syntaxBlitz
                        )
                        
                        coverActionCard(
                            title: "Silicon Dispatcher",
                            subtitle: "Direct 38 TOPS Neural Engine Bus",
                            icon: "cpu.fill",
                            tint: ArcadeTheme.siliconGreen,
                            sheet: .siliconArchitect
                        )
                        
                        coverActionCard(
                            title: "Ask Ada Neural Tutor",
                            subtitle: "Apple Intelligence On-Device Copilot",
                            icon: "brain.head.profile",
                            tint: ArcadeTheme.cupertinoCyan,
                            sheet: .aiTutor
                        )
                        
                        coverActionCard(
                            title: "Apple Ecosystem Matrix",
                            subtitle: "WWDC Milestones & Framework Timeline",
                            icon: "apple.logo",
                            tint: ArcadeTheme.neuralViolet,
                            sheet: .ecosystemMatrix
                        )
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .syntaxBlitz:
                SwiftSyntaxBlitzView()
            case .hingeHack:
                HingeHackView()
            case .siliconArchitect:
                AppleSiliconArchitectView()
            case .ecosystemMatrix:
                EcosystemMatrixView()
            case .aiTutor:
                AITutorSheetView()
            case .trophyRoom:
                TrophyRoomView()
            case .moduleDetail(let mod):
                ModuleDetailSheetView(module: mod)
            }
        }
    }
    
    // MARK: - Dynamic Island 3.0 Pill
    private var dynamicIslandActivityPill: some View {
        HStack(spacing: 12) {
            Image(systemName: "apple.logo")
                .foregroundStyle(ArcadeTheme.arcadeCrimson)
                .font(.caption)
            
            Text("Arcade Live • Level \(profile.playerXP / 500 + 1)")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(ArcadeTheme.swiftOrange)
                Text("\(profile.dailyStreak)d")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .padding(.top, 4)
    }
    
    @ViewBuilder
    private func coverActionCard(
        title: String,
        subtitle: String,
        icon: String,
        tint: Color,
        sheet: ActiveArcadeSheet
    ) -> some View {
        Button {
            activeSheet = sheet
            SoundEngine.shared.playTap()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.2))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(tint)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding()
            .liquidGlassCard(cornerRadius: 18, tint: tint)
        }
        .springPress()
    }
}

