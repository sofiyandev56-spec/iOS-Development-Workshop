import SwiftUI
import Combine

/// Trophy awarded to the player
public struct ArcadeTrophy: Identifiable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let iconName: String
    public let accentColor: Color
    public var isUnlocked: Bool
    public let requirement: String
}

/// Player Arcade Progression State
public final class ArcadeProfileManager: ObservableObject {
    public static let shared = ArcadeProfileManager()
    
    @Published public var playerName: String = "Swift Pioneer"
    @Published public var playerXP: Int = 1450
    @Published public var arcadeCoins: Int = 320
    @Published public var dailyStreak: Int = 5
    @Published public var bestStreak: Int = 12
    
    // Game Best Scores
    @Published public var syntaxBlitzHighScore: Int = 2800
    @Published public var hingeHackHighScore: Int = 3450
    @Published public var siliconArchitectHighScore: Int = 1950
    @Published public var matrixHighScore: Int = 1600
    
    // Trophies
    @Published public var trophies: [ArcadeTrophy] = [
        ArcadeTrophy(
            id: "trophy-infinite-loop",
            title: "Infinite Loop Keynote",
            subtitle: "Completed Swift Core Foundations",
            iconName: "apple.logo",
            accentColor: ArcadeTheme.arcadeCrimson,
            isUnlocked: true,
            requirement: "Answer 10 Swift fundamentals questions with 100% accuracy"
        ),
        ArcadeTrophy(
            id: "trophy-hinge-master",
            title: "Hinge Sensei",
            subtitle: "Folded iPhone Duo in mid-game",
            iconName: "rectangle.split.2x1.fill",
            accentColor: ArcadeTheme.cupertinoCyan,
            isUnlocked: true,
            requirement: "Transition between Book, Flat, and Tabletop postures during active gameplay"
        ),
        ArcadeTrophy(
            id: "trophy-neural-titan",
            title: "Neural Engine Titan",
            subtitle: "Achieved 38 TOPS in Silicon Architect",
            iconName: "cpu.fill",
            accentColor: ArcadeTheme.siliconGreen,
            isUnlocked: true,
            requirement: "Reach a 5x combo in Apple Silicon Architect"
        ),
        ArcadeTrophy(
            id: "trophy-concurrency-shield",
            title: "Actor Isolation Master",
            subtitle: "Zero Concurrency Violations",
            iconName: "bolt.shield.fill",
            accentColor: ArcadeTheme.neuralViolet,
            isUnlocked: false,
            requirement: "Survive 3 minutes in Hinge Hack without any main-thread drops"
        ),
        ArcadeTrophy(
            id: "trophy-steve-jobs-theater",
            title: "Steve Jobs Theater Pass",
            subtitle: "Apple Arcade Hall of Fame",
            iconName: "sparkles.tv.fill",
            accentColor: ArcadeTheme.liquidGold,
            isUnlocked: false,
            requirement: "Score over 10,000 combined XP across all 4 arcade mini-games"
        )
    ]
    
    private init() {}
    
    public var currentLevelTitle: String {
        switch playerXP {
        case 0..<500: return "Junior Cocoa Developer"
        case 500..<1200: return "CoreOS System Engineer"
        case 1200..<2500: return "Senior Swift Architect"
        case 2500..<5000: return "Principal Silicon Fellow"
        default: return "Apple Distinguished Engineer"
        }
    }
    
    public var nextLevelThreshold: Int {
        switch playerXP {
        case 0..<500: return 500
        case 500..<1200: return 1200
        case 1200..<2500: return 2500
        case 2500..<5000: return 5000
        default: return 10000
        }
    }
    
    public var progressToNextLevel: Double {
        let maxXP = Double(nextLevelThreshold)
        return min(1.0, Double(playerXP) / maxXP)
    }
    
    public func addXP(_ amount: Int) {
        playerXP += amount
        arcadeCoins += amount / 10
        SoundEngine.shared.playSuccess()
    }
}

