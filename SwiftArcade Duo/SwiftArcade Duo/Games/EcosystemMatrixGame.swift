import SwiftUI
import Combine

/// Matrix milestone link
public struct MatrixMilestone: Identifiable {
    public let id = UUID()
    public let milestone: String
    public let year: String
    public let targetFramework: String
    public let clue: String
}

/// Ecosystem Matrix Mini-Game View
public struct EcosystemMatrixView: View {
    @ObservedObject private var profile = ArcadeProfileManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var score: Int = 0
    @State private var currentIndex: Int = 0
    @State private var selectedAnswer: String? = nil
    @State private var feedbackText: String = "Match the Apple innovation milestone to its core architectural framework."
    @State private var feedbackColor: Color = ArcadeTheme.cupertinoCyan
    @State private var isGameComplete: Bool = false
    
    private let milestones: [MatrixMilestone] = [
        MatrixMilestone(
            milestone: "WWDC 2014 Swift Unveiling",
            year: "2014",
            targetFramework: "Swift Standard Library",
            clue: "Craig Federighi announced 'Objective-C without the C', modernizing Apple software development."
        ),
        MatrixMilestone(
            milestone: "NeXTSTEP Integration into OS X",
            year: "1997",
            targetFramework: "Cocoa & Foundation (NSObject)",
            clue: "Steve Jobs brought object-oriented Cocoa frameworks that power Mac and iPhone to this day."
        ),
        MatrixMilestone(
            milestone: "WWDC 2019 Declarative Revolution",
            year: "2019",
            targetFramework: "SwiftUI & Combine",
            clue: "Declarative syntax replaced imperative view controllers across all Apple platforms."
        ),
        MatrixMilestone(
            milestone: "Apple Silicon M1 Launch",
            year: "2020",
            targetFramework: "Metal & Rosetta 2",
            clue: "Unified Memory and Apple-designed ARM silicon disrupted the computing industry."
        ),
        MatrixMilestone(
            milestone: "iPhone Duo Foldable Launch",
            year: "2026",
            targetFramework: "Liquid Glass & DualDisplayKit",
            clue: "The continuous dual-OLED hinge introduced real-time posture geometry and specular morphing."
        )
    ]
    
    private let frameworkOptions: [String] = [
        "Swift Standard Library",
        "Cocoa & Foundation (NSObject)",
        "SwiftUI & Combine",
        "Metal & Rosetta 2",
        "Liquid Glass & DualDisplayKit"
    ]
    
    public init() {}
    
    private var current: MatrixMilestone {
        milestones[currentIndex % milestones.count]
    }
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            if isGameComplete {
                VStack(spacing: 20) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 60))
                        .foregroundStyle(ArcadeTheme.neuralGradient)
                        .neonGlow(color: ArcadeTheme.neuralViolet, radius: 20)
                    
                    Text("Ecosystem Matrix Mastered!")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    
                    Text("Final Score: \(score) pts")
                        .font(.system(.title2, design: .monospaced, weight: .bold))
                        .foregroundStyle(ArcadeTheme.siliconGreen)
                    
                    Text("You demonstrated mastery of Apple's historical milestones from NeXTSTEP to iPhone Duo.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        restartGame()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Play Again")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(ArcadeTheme.neuralGradient)
                        .clipShape(Capsule())
                        .neonGlow(color: ArcadeTheme.neuralViolet, radius: 12)
                    }
                    .springPress()
                }
                .padding()
            } else {
                VStack(spacing: 16) {
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
                        Text("ECOSYSTEM MATRIX")
                            .font(.system(.headline, design: .monospaced, weight: .black))
                            .foregroundStyle(ArcadeTheme.neuralGradient)
                        Text("Timeline & Framework Architecture")
                            .font(.system(size: 9))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Text("\(score) pts")
                        .font(.system(.subheadline, design: .monospaced, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .liquidGlassCard(cornerRadius: 12, tint: ArcadeTheme.neuralViolet)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Current Milestone Card
                VStack(spacing: 8) {
                    HStack {
                        Text(current.year)
                            .font(.system(.caption, design: .monospaced, weight: .black))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(ArcadeTheme.neuralViolet)
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text("MILESTONE \(currentIndex + 1) OF \(milestones.count)")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                    Text(current.milestone)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(current.clue)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.neuralViolet)
                .padding(.horizontal)
                
                // Feedback
                Text(feedbackText)
                    .font(.caption.bold())
                    .foregroundStyle(feedbackColor)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(feedbackColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                
                // Framework Choices
                VStack(spacing: 10) {
                    ForEach(frameworkOptions, id: \.self) { opt in
                        Button {
                            verifyAnswer(opt)
                        } label: {
                            HStack {
                                Image(systemName: "app.badge.fill")
                                    .foregroundStyle(ArcadeTheme.neuralViolet)
                                Text(opt)
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                                Image(systemName: "checkmark.circle")
                                    .foregroundStyle(.white.opacity(0.4))
                            }
                            .padding()
                            .liquidGlassCard(cornerRadius: 14, tint: ArcadeTheme.neuralViolet)
                        }
                        .springPress()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}
    
    private func verifyAnswer(_ selected: String) {
        if selected == current.targetFramework {
            score += 250
            profile.addXP(40)
            SoundEngine.shared.playSuccess()
            feedbackText = "CORRECT! '\(selected)' was critical to \(current.year)."
            feedbackColor = ArcadeTheme.siliconGreen
        } else {
            SoundEngine.shared.playError()
            feedbackText = "Incorrect! The foundational framework was '\(current.targetFramework)'."
            feedbackColor = ArcadeTheme.arcadeCrimson
            
            AITutorEngine.shared.diagnoseMistake(
                concept: current.milestone,
                selectedAnswer: selected,
                correctAnswer: current.targetFramework
            )
        }
        
        currentIndex += 1
        if currentIndex >= milestones.count {
            isGameComplete = true
            SoundEngine.shared.playLevelUp()
            if score > profile.matrixHighScore {
                profile.matrixHighScore = score
            }
        }
    }
    
    private func restartGame() {
        score = 0
        currentIndex = 0
        isGameComplete = false
        feedbackText = "Match the Apple innovation milestone to its core architectural framework."
        feedbackColor = ArcadeTheme.cupertinoCyan
    }
}

