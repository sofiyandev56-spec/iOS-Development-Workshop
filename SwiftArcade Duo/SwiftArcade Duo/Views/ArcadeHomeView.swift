import SwiftUI
import Combine

/// Active sheet presentation
public enum ActiveArcadeSheet: Identifiable {
    case syntaxBlitz
    case hingeHack
    case siliconArchitect
    case ecosystemMatrix
    case aiTutor
    case trophyRoom
    case moduleDetail(LearningModule)
    
    public var id: String {
        switch self {
        case .syntaxBlitz: return "syntaxBlitz"
        case .hingeHack: return "hingeHack"
        case .siliconArchitect: return "siliconArchitect"
        case .ecosystemMatrix: return "ecosystemMatrix"
        case .aiTutor: return "aiTutor"
        case .trophyRoom: return "trophyRoom"
        case .moduleDetail(let mod): return "module-\(mod.id)"
        }
    }
}

/// The Main Apple Arcade Hub View
public struct ArcadeHomeView: View {
    @ObservedObject var profile = ArcadeProfileManager.shared
    @ObservedObject var foldableManager = FoldableDeviceManager.shared
    
    @State private var activeSheet: ActiveArcadeSheet? = nil
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Top Brand & Profile Status Bar
                topBrandBar
                
                // Hero Spotlight Banner
                heroSpotlightBanner
                
                // Arcade Mini-Games Showcase
                miniGamesSection
                
                // Apple Engineering Pillars & Curriculum
                curriculumSection
                
                // Bottom Spacing for floating simulator
                Color.clear.frame(height: 70)
            }
            .padding(.vertical)
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
    
    // MARK: - Top Brand Bar
    private var topBrandBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: "apple.logo")
                        .foregroundStyle(.white)
                    Text("SwiftArcade")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("DUO")
                        .font(.caption.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(ArcadeTheme.arcadeCrimson)
                        .clipShape(Capsule())
                }
                
                Text("Apple Neural Learning Platform")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Buttons for AI Mentor & Trophies
            HStack(spacing: 8) {
                Button {
                    activeSheet = .aiTutor
                    SoundEngine.shared.playTap()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "brain.head.profile")
                            .foregroundStyle(ArcadeTheme.cupertinoCyan)
                        Text("Ada AI")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .liquidGlassCard(cornerRadius: 14, tint: ArcadeTheme.cupertinoCyan)
                }
                .springPress()
                
                Button {
                    activeSheet = .trophyRoom
                    SoundEngine.shared.playTap()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(ArcadeTheme.liquidGold)
                        Text("\(profile.playerXP)")
                            .font(.system(.caption, design: .monospaced, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .liquidGlassCard(cornerRadius: 14, tint: ArcadeTheme.liquidGold)
                }
                .springPress()
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Hero Spotlight Banner
    private var heroSpotlightBanner: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("FEATURED MINI-GAME")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(ArcadeTheme.arcadeCrimson)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(ArcadeTheme.swiftOrange)
                    Text("\(profile.dailyStreak) Day Streak")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
            }
            
            Text("Hinge Hack: The Foldable Concurrency Balancer")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text("Balance UI and Background Actor execution across the iPhone Duo physical hinge! Fold the phone in mid-air to unlock Quantum Hinge bus bandwidth.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            
            HStack {
                Button {
                    activeSheet = .hingeHack
                    SoundEngine.shared.playSelect()
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Play Now (iPhone Duo)")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(ArcadeTheme.arcadeGradient)
                    .clipShape(Capsule())
                    .neonGlow(color: ArcadeTheme.arcadeCrimson, radius: 12)
                }
                .springPress()
                
                Spacer()
                
                Image(systemName: "rectangle.split.2x1.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(ArcadeTheme.cupertinoCyan.opacity(0.7))
            }
        }
        .padding(20)
        .liquidGlassCard(cornerRadius: 24, tint: ArcadeTheme.arcadeCrimson, strokeOpacity: 0.5)
        .padding(.horizontal)
    }
    
    // MARK: - Mini-Games Section
    private var miniGamesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("ARCADE MINI-GAMES")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text("4 Games Loaded")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(ArcadeTheme.cupertinoCyan)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Game 1: Swift Syntax Blitz
                    gameCard(
                        title: "Syntax Blitz",
                        subtitle: "Speedrun Swift 6 memory & concurrency",
                        icon: "bolt.fill",
                        tint: ArcadeTheme.arcadeCrimson,
                        highScore: profile.syntaxBlitzHighScore,
                        sheet: .syntaxBlitz
                    )
                    
                    // Game 2: Hinge Hack
                    gameCard(
                        title: "Hinge Hack",
                        subtitle: "Fold-responsive dual screen balancer",
                        icon: "rectangle.split.2x1.fill",
                        tint: ArcadeTheme.cupertinoCyan,
                        highScore: profile.hingeHackHighScore,
                        sheet: .hingeHack
                    )
                    
                    // Game 3: Silicon Architect
                    gameCard(
                        title: "Silicon Architect",
                        subtitle: "Route workloads to UMA, GPU & ANE",
                        icon: "cpu.fill",
                        tint: ArcadeTheme.siliconGreen,
                        highScore: profile.siliconArchitectHighScore,
                        sheet: .siliconArchitect
                    )
                    
                    // Game 4: Ecosystem Matrix
                    gameCard(
                        title: "Ecosystem Matrix",
                        subtitle: "Historical Apple innovations web",
                        icon: "circle.grid.cross.fill",
                        tint: ArcadeTheme.neuralViolet,
                        highScore: profile.matrixHighScore,
                        sheet: .ecosystemMatrix
                    )
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func gameCard(
        title: String,
        subtitle: String,
        icon: String,
        tint: Color,
        highScore: Int,
        sheet: ActiveArcadeSheet
    ) -> some View {
        Button {
            activeSheet = sheet
            SoundEngine.shared.playTap()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(tint)
                }
                
                Text(title)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    Text("Best: \(highScore)")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.6))
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .font(.title3)
                        .foregroundStyle(tint)
                }
            }
            .padding()
            .frame(width: 170, height: 200)
            .liquidGlassCard(cornerRadius: 20, tint: tint)
        }
        .springPress()
    }
    
    // MARK: - Curriculum Section
    private var curriculumSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("APPLE CURRICULUM DEEP DIVES")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text("5 Core Pillars")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(ArcadeTheme.siliconGreen)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(CurriculumRepository.sharedModules) { mod in
                    Button {
                        activeSheet = .moduleDetail(mod)
                        SoundEngine.shared.playTap()
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.08))
                                    .frame(width: 44, height: 44)
                                Image(systemName: mod.domain.icon)
                                    .foregroundStyle(ArcadeTheme.cupertinoCyan)
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(mod.title)
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text(mod.difficulty)
                                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(ArcadeTheme.neuralViolet.opacity(0.5))
                                        .clipShape(Capsule())
                                }
                                
                                Text(mod.summary)
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.7))
                                    .lineLimit(2)
                            }
                        }
                        .padding()
                        .liquidGlassCard(cornerRadius: 16, tint: ArcadeTheme.cupertinoCyan, strokeOpacity: 0.25)
                    }
                    .springPress()
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Module Detail & Quiz View
public struct ModuleDetailSheetView: View {
    public let module: LearningModule
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: Int? = nil
    @State private var hasAnswered: Bool = false
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        Spacer()
                        Label(module.domain.rawValue, systemImage: module.domain.icon)
                            .font(.caption.bold())
                            .foregroundStyle(ArcadeTheme.cupertinoCyan)
                    }
                    
                    Text(module.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    
                    Text(module.deepDive)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.85))
                    
                    // Code Block
                    Text(module.codeSnippet)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(ArcadeTheme.siliconGreen)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Trivia Card
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(ArcadeTheme.liquidGold)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Apple Engineering Trivia")
                                .font(.caption.bold())
                                .foregroundStyle(ArcadeTheme.liquidGold)
                            Text(module.triviaFact)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding()
                    .liquidGlassCard(cornerRadius: 16, tint: ArcadeTheme.liquidGold)
                    
                    // Knowledge Check Quiz
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Knowledge Check")
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        Text(module.sampleQuestion.prompt)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                        
                        ForEach(0..<module.sampleQuestion.options.count, id: \.self) { idx in
                            Button {
                                selectedOption = idx
                                hasAnswered = true
                                if idx == module.sampleQuestion.correctIndex {
                                    SoundEngine.shared.playSuccess()
                                    ArcadeProfileManager.shared.addXP(50)
                                } else {
                                    SoundEngine.shared.playError()
                                }
                            } label: {
                                HStack {
                                    Text(module.sampleQuestion.options[idx])
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    if hasAnswered {
                                        if idx == module.sampleQuestion.correctIndex {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(ArcadeTheme.siliconGreen)
                                        } else if idx == selectedOption {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(ArcadeTheme.arcadeCrimson)
                                        }
                                    }
                                }
                                .padding()
                                .liquidGlassCard(
                                    cornerRadius: 12,
                                    tint: hasAnswered && idx == module.sampleQuestion.correctIndex ? ArcadeTheme.siliconGreen : Color.clear
                                )
                            }
                        }
                        
                        if hasAnswered {
                            Text(module.sampleQuestion.explanation)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(10)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding()
                    .liquidGlassCard(cornerRadius: 18, tint: ArcadeTheme.cupertinoCyan)
                }
                .padding()
            }
        }
    }
}

