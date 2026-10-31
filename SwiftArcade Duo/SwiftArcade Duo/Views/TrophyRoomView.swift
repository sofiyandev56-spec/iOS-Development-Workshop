import SwiftUI
import Combine

/// Trophy Room & Apple Developer Hall of Fame
public struct TrophyRoomView: View {
    @ObservedObject var profile = ArcadeProfileManager.shared
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("DEVELOPER TROPHY ROOM")
                            .font(.system(.headline, design: .monospaced, weight: .black))
                            .foregroundStyle(ArcadeTheme.arcadeGradient)
                        Text("Cupertino Honors & Badges")
                            .font(.system(size: 9))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "circle.hexagongrid.fill")
                            .foregroundStyle(ArcadeTheme.liquidGold)
                        Text("\(profile.arcadeCoins)")
                            .font(.system(.subheadline, design: .monospaced, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Level Summary Banner
                        VStack(spacing: 8) {
                            Text(profile.currentLevelTitle)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            
                            HStack {
                                Text("\(profile.playerXP) XP")
                                    .font(.system(.caption, design: .monospaced, weight: .bold))
                                    .foregroundStyle(ArcadeTheme.cupertinoCyan)
                                Spacer()
                                Text("Next: \(profile.nextLevelThreshold) XP")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            
                            ProgressView(value: profile.progressToNextLevel)
                                .tint(ArcadeTheme.arcadeGradient)
                        }
                        .padding()
                        .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.arcadeCrimson)
                        
                        // Trophies Grid
                        VStack(spacing: 12) {
                            ForEach(profile.trophies) { trophy in
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(trophy.isUnlocked ? trophy.accentColor.opacity(0.2) : Color.white.opacity(0.05))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: trophy.iconName)
                                            .font(.title2)
                                            .foregroundStyle(trophy.isUnlocked ? trophy.accentColor : Color.white.opacity(0.3))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack {
                                            Text(trophy.title)
                                                .font(.headline)
                                                .foregroundStyle(trophy.isUnlocked ? .white : .white.opacity(0.4))
                                            
                                            Spacer()
                                            
                                            if trophy.isUnlocked {
                                                Image(systemName: "checkmark.seal.fill")
                                                    .foregroundStyle(ArcadeTheme.siliconGreen)
                                            } else {
                                                Image(systemName: "lock.fill")
                                                    .foregroundStyle(.white.opacity(0.3))
                                            }
                                        }
                                        
                                        Text(trophy.subtitle)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.7))
                                        
                                        Text(trophy.requirement)
                                            .font(.system(size: 9))
                                            .foregroundStyle(.white.opacity(0.4))
                                    }
                                }
                                .padding()
                                .liquidGlassCard(cornerRadius: 16, tint: trophy.isUnlocked ? trophy.accentColor : Color.clear)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

