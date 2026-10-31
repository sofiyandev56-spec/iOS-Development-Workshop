import SwiftUI
import Combine

/// Challenge card for Swift Syntax Blitz
public struct SyntaxChallenge: Identifiable {
    public let id = UUID()
    public let title: String
    public let question: String
    public let codeSnippet: String
    public let options: [String]
    public let correctIndex: Int
    public let explanation: String
    public let category: String
}

/// Swift Syntax Blitz Mini-Game Engine
public final class SwiftSyntaxBlitzEngine: ObservableObject {
    @Published public var score: Int = 0
    @Published public var streak: Int = 0
    @Published public var multiplier: Int = 1
    @Published public var timeRemaining: Double = 15.0
    @Published public var isGameOver: Bool = false
    @Published public var currentIndex: Int = 0
    @Published public var feedbackMessage: String = "Tap the correct token before time expires!"
    @Published public var feedbackColor: Color = .secondary
    
    private var timerSubscription: AnyCancellable?
    
    public let challenges: [SyntaxChallenge] = [
        SyntaxChallenge(
            title: "Actor Concurrency Check",
            question: "How do you ensure this closure executes strictly on the Main thread?",
            codeSnippet: "func updateUI() {\n    Task { /* ??? */ in\n        self.label.text = \"Ready\"\n    }\n}",
            options: ["@MainActor", "@Sendable", "@Isolated", "@Dispatch"],
            correctIndex: 0,
            explanation: "`@MainActor` binds task execution to the main UI runloop.",
            category: "Swift 6 Concurrency"
        ),
        SyntaxChallenge(
            title: "Memory Safety & ARC",
            question: "Which capture modifier prevents a retain cycle in this closure?",
            codeSnippet: "networkClient.fetch { [/* ??? */ self] result in\n    self?.update(result)\n}",
            options: ["weak", "unowned", "isolated", "copy"],
            correctIndex: 0,
            explanation: "`[weak self]` creates an optional reference that does not increment retain count.",
            category: "ARC & Memory"
        ),
        SyntaxChallenge(
            title: "Value vs Reference Semantics",
            question: "Mutating an instance of which Swift construct modifies its local copy without altering the original?",
            codeSnippet: "var copy = original\ncopy.score += 10\n// original.score is UNCHANGED",
            options: ["struct", "class", "actor", "NSObject"],
            correctIndex: 0,
            explanation: "Structs possess value semantics (copy-on-write). Classes and Actors share reference storage.",
            category: "Swift Foundations"
        ),
        SyntaxChallenge(
            title: "Liquid Glass Modifier",
            question: "Which modifier adds Apple's iOS 26 dynamic specular reflection to a view?",
            codeSnippet: "Text(\"Arcade Button\")\n    ./* ??? */()",
            options: [".glassEffect()", ".material()", ".specularGlow()", ".dynamicBlur()"],
            correctIndex: 0,
            explanation: "`.glassEffect()` is the native iOS 26 Liquid Glass modifier.",
            category: "iOS 26 Design"
        ),
        SyntaxChallenge(
            title: "Unified Memory Access",
            question: "What capability allows Apple Neural Engine and GPU to compute over shared memory without copying?",
            codeSnippet: "// Zero-copy pointer sharing across ANE & GPU\nlet memoryPool = AppleSilicon.UMA",
            options: ["Unified Memory Architecture", "PCIe Bus Mirroring", "Dynamic Paging", "SRAM Swap"],
            correctIndex: 0,
            explanation: "Apple's UMA shares a high-bandwidth unified RAM pool between CPU, GPU, and ANE.",
            category: "Apple Silicon"
        )
    ]
    
    public init() {
        startNewGame()
    }
    
    public var currentChallenge: SyntaxChallenge {
        challenges[currentIndex % challenges.count]
    }
    
    public func startNewGame() {
        score = 0
        streak = 0
        multiplier = 1
        timeRemaining = 15.0
        isGameOver = false
        currentIndex = 0
        feedbackMessage = "Race against the clock! Build your multiplier!"
        feedbackColor = ArcadeTheme.cupertinoCyan
        
        startTimer()
    }
    
    private func startTimer() {
        timerSubscription?.cancel()
        timerSubscription = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 0.1
                } else {
                    self.handleTimeExpired()
                }
            }
    }
    
    private func handleTimeExpired() {
        SoundEngine.shared.playError()
        streak = 0
        multiplier = 1
        feedbackMessage = "Time expired! Concurrency clock penalty!"
        feedbackColor = ArcadeTheme.arcadeCrimson
        nextChallenge()
    }
    
    public func selectOption(at index: Int) {
        guard !isGameOver else { return }
        
        let challenge = currentChallenge
        if index == challenge.correctIndex {
            // Correct
            streak += 1
            if streak >= 5 { multiplier = 4 }
            else if streak >= 3 { multiplier = 3 }
            else if streak >= 2 { multiplier = 2 }
            else { multiplier = 1 }
            
            let pointsWon = Int(timeRemaining * 20) * multiplier
            score += pointsWon
            ArcadeProfileManager.shared.addXP(pointsWon / 2)
            
            SoundEngine.shared.playCombo()
            feedbackMessage = "Correct! +\(pointsWon) XP (Combo \(multiplier)x)"
            feedbackColor = ArcadeTheme.siliconGreen
        } else {
            // Wrong
            SoundEngine.shared.playError()
            streak = 0
            multiplier = 1
            feedbackMessage = "Incorrect! " + challenge.explanation
            feedbackColor = ArcadeTheme.arcadeCrimson
            
            // Notify AI tutor
            AITutorEngine.shared.diagnoseMistake(
                concept: challenge.title,
                selectedAnswer: challenge.options[index],
                correctAnswer: challenge.options[challenge.correctIndex]
            )
        }
        
        nextChallenge()
    }
    
    private func nextChallenge() {
        currentIndex += 1
        if currentIndex >= challenges.count * 2 {
            isGameOver = true
            timerSubscription?.cancel()
            SoundEngine.shared.playLevelUp()
            if score > ArcadeProfileManager.shared.syntaxBlitzHighScore {
                ArcadeProfileManager.shared.syntaxBlitzHighScore = score
            }
        } else {
            timeRemaining = 15.0
        }
    }
}

/// Swift Syntax Blitz Game View with Foldable Duo Adaptive Layout
public struct SwiftSyntaxBlitzView: View {
    @StateObject private var engine = SwiftSyntaxBlitzEngine()
    @ObservedObject private var foldableManager = FoldableDeviceManager.shared
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            if engine.isGameOver {
                gameOverView
            } else {
                VStack(spacing: 0) {
                    // Top Game Navigation & Status Bar
                    gameHeaderBar
                    
                    // Active Game Screen Layout
                    if foldableManager.isDualScreen {
                        dualPaneGameLayout
                    } else {
                        singlePaneGameLayout
                    }
                }
            }
        }
    }
    
    // MARK: - Game Over View
    private var gameOverView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(ArcadeTheme.arcadeCrimson)
                .neonGlow(color: ArcadeTheme.arcadeCrimson, radius: 24)
            
            Text("Blitz Sprint Complete!")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Final Score: \(engine.score) pts")
                .font(.system(.title2, design: .monospaced, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(ArcadeTheme.liquidGold)
            
            HStack(spacing: 20) {
                VStack {
                    Text("Personal Best")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    Text("\(ArcadeProfileManager.shared.syntaxBlitzHighScore)")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                }
                .padding()
                .liquidGlassCard(cornerRadius: 14)
                
                VStack {
                    Text("Peak Combo")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    Text("\(engine.multiplier)x")
                        .font(.headline.bold())
                        .foregroundStyle(ArcadeTheme.arcadeCrimson)
                }
                .padding()
                .liquidGlassCard(cornerRadius: 14)
            }
            
            Button {
                engine.startNewGame()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Play Again")
                        .font(.headline)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 14)
                .background(ArcadeTheme.arcadeGradient)
                .clipShape(Capsule())
                .neonGlow(color: ArcadeTheme.arcadeCrimson, radius: 14)
            }
            .springPress()
            
            Button {
                dismiss()
            } label: {
                Text("Exit to Arcade")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding()
    }
    
    // MARK: - Game Header Bar
    private var gameHeaderBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
            
            // Score & Multiplier Pill
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(ArcadeTheme.liquidGold)
                    Text("\(engine.score)")
                        .font(.system(.title3, design: .monospaced, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                if engine.multiplier > 1 {
                    Text("\(engine.multiplier)x")
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(ArcadeTheme.arcadeCrimson)
                        .clipShape(Capsule())
                        .neonGlow(color: ArcadeTheme.arcadeCrimson, radius: 8)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .liquidGlassCard(cornerRadius: 16, tint: ArcadeTheme.arcadeCrimson)
            
            Spacer()
            
            // Time remaining meter
            HStack(spacing: 4) {
                Image(systemName: "stopwatch.fill")
                    .foregroundStyle(ArcadeTheme.cupertinoCyan)
                Text(String(format: "%.1fs", engine.timeRemaining))
                    .font(.system(.body, design: .monospaced, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    // MARK: - Dual Pane Layout (iPhone Duo 180° Flat or 120° Book)
    private var dualPaneGameLayout: some View {
        HStack(spacing: 0) {
            // Left Pane: Code Inspector & Terminal
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label(engine.currentChallenge.category, systemImage: "terminal.fill")
                        .font(.caption.bold())
                        .foregroundStyle(ArcadeTheme.cupertinoCyan)
                    
                    Spacer()
                    
                    Text("LEFT SCREEN • TERMINAL")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.4))
                }
                
                Text(engine.currentChallenge.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Text(engine.currentChallenge.question)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                
                // Code Terminal Screen
                ScrollView {
                    Text(engine.currentChallenge.codeSnippet)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(ArcadeTheme.siliconGreen)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                }
                
                // Live Feedback Banner
                Text(engine.feedbackMessage)
                    .font(.caption.bold())
                    .foregroundStyle(engine.feedbackColor)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(engine.feedbackColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Central Dynamic Hinge Crease
            HingeDividerView(creaseWidth: foldableManager.creaseWidth)
            
            // Right Pane: Interactive Answer Matrix & Ada Neural Feedback
            VStack(spacing: 14) {
                HStack {
                    Text("RIGHT SCREEN • ACTION PAD")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.4))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(ArcadeTheme.swiftOrange)
                        Text("Streak: \(engine.streak)")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    }
                }
                
                Text("Select the Missing Token")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 4 Interactive Options
                VStack(spacing: 12) {
                    ForEach(0..<engine.currentChallenge.options.count, id: \.self) { idx in
                        Button {
                            engine.selectOption(at: idx)
                        } label: {
                            HStack {
                                Text(engine.currentChallenge.options[idx])
                                    .font(.system(.body, design: .monospaced, weight: .bold))
                                    .foregroundStyle(.white)
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundStyle(ArcadeTheme.arcadeCrimson)
                            }
                            .padding()
                            .liquidGlassCard(cornerRadius: 16, tint: ArcadeTheme.arcadeCrimson, strokeOpacity: 0.4)
                        }
                        .springPress()
                    }
                }
                
                Spacer()
                
                // Real-time Hinge posture tag
                HStack {
                    Image(systemName: foldableManager.currentPosture.iconName)
                    Text("iPhone Duo: \(foldableManager.currentPosture.rawValue)")
                }
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Single Pane Layout (iPhone 18 Pro Max & Closed Cover)
    private var singlePaneGameLayout: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header category
                HStack {
                    Label(engine.currentChallenge.category, systemImage: "bolt.fill")
                        .font(.caption.bold())
                        .foregroundStyle(ArcadeTheme.cupertinoCyan)
                    Spacer()
                    Text("Streak: \(engine.streak) 🔥")
                        .font(.caption.bold())
                        .foregroundStyle(ArcadeTheme.swiftOrange)
                }
                
                Text(engine.currentChallenge.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(engine.currentChallenge.question)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Code block
                Text(engine.currentChallenge.codeSnippet)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(ArcadeTheme.siliconGreen)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
                Text(engine.feedbackMessage)
                    .font(.caption.bold())
                    .foregroundStyle(engine.feedbackColor)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(engine.feedbackColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Option Buttons
                VStack(spacing: 10) {
                    ForEach(0..<engine.currentChallenge.options.count, id: \.self) { idx in
                        Button {
                            engine.selectOption(at: idx)
                        } label: {
                            HStack {
                                Text(engine.currentChallenge.options[idx])
                                    .font(.system(.body, design: .monospaced, weight: .bold))
                                    .foregroundStyle(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            .padding()
                            .liquidGlassCard(cornerRadius: 14, tint: ArcadeTheme.arcadeCrimson)
                        }
                        .springPress()
                    }
                }
            }
            .padding()
        }
    }
}

/// Realistic Hinge Crease Divider for iPhone Duo
public struct HingeDividerView: View {
    public var creaseWidth: CGFloat
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.7),
                            ArcadeTheme.hingeSilver,
                            Color.black.opacity(0.7)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: max(6, creaseWidth))
            
            // Specular Reflection Line on Hinge Axis
            Rectangle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 1.5)
        }
        .ignoresSafeArea()
    }
}

