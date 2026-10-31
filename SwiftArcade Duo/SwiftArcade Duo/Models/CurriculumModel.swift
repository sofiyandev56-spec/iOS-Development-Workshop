import Foundation

/// Core Knowledge Domains for Apple Developer Mastery
public enum AppleDomain: String, CaseIterable, Identifiable {
    case swiftConcurrency = "Swift Concurrency & Safe Code"
    case swiftUIFoldable = "SwiftUI & Foldable Architecture"
    case appleSilicon = "Apple Silicon & ANE Architecture"
    case ecosystemHeritage = "Apple Heritage & Ecosystem"
    case foundationAI = "On-Device AI & Foundation Models"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .swiftConcurrency: return "bolt.shield.fill"
        case .swiftUIFoldable: return "rectangle.split.2x1.fill"
        case .appleSilicon: return "cpu.fill"
        case .ecosystemHeritage: return "apple.logo"
        case .foundationAI: return "brain.head.profile"
        }
    }
}

/// A specific learning module with rich Apple technical depth
public struct LearningModule: Identifiable {
    public let id: String
    public let title: String
    public let domain: AppleDomain
    public let badgeName: String
    public let difficulty: String
    public let summary: String
    public let deepDive: String
    public let codeSnippet: String
    public let triviaFact: String
    public let sampleQuestion: QuizQuestion
}

/// Interactive quiz question
public struct QuizQuestion: Identifiable {
    public let id: String
    public let prompt: String
    public let codeContext: String?
    public let options: [String]
    public let correctIndex: Int
    public let explanation: String
    public let appleDocReference: String
}

/// Curriculum Repository: Loaded with authentic, high-level Apple Engineering concepts
public struct CurriculumRepository {
    public static let sharedModules: [LearningModule] = [
        LearningModule(
            id: "swift-actors",
            title: "Actor Isolation & Thread Safety",
            domain: .swiftConcurrency,
            badgeName: "Actor Shield",
            difficulty: "Pro",
            summary: "Learn how Swift 6 Actors guarantee compile-time elimination of data races through synchronization boundaries.",
            deepDive: "Unlike classes that permit concurrent mutable state access, an actor isolates its state so that only one task can execute its code at a given time. Cross-actor calls require `await`.",
            codeSnippet: """
            actor BankAccount {
                private var balance: Double = 0
                
                func deposit(amount: Double) {
                    balance += amount
                }
            }
            
            // Calling from outside requires async/await
            await account.deposit(amount: 500)
            """,
            triviaFact: "Swift 6 full data isolation guarantees that if your project compiles, it is physically impossible to crash due to simultaneous memory read/write races.",
            sampleQuestion: QuizQuestion(
                id: "q-actor-1",
                prompt: "Which keyword is mandatory when accessing mutable state on an actor from an external context?",
                codeContext: "let balance = ... account.currentBalance()",
                options: ["sync", "await", "isolated", "defer"],
                correctIndex: 1,
                explanation: "External access to an actor's mutable state is asynchronous and must be suspended with 'await'.",
                appleDocReference: "Apple Developer Documentation: Concurrency & Actors"
            )
        ),
        
        LearningModule(
            id: "swiftui-foldable",
            title: "Liquid Glass & Hinge Geometry",
            domain: .swiftUIFoldable,
            badgeName: "Liquid Prism",
            difficulty: "Master",
            summary: "Designing adaptive interfaces for the iPhone Duo using Liquid Glass, dynamic blur, and continuous fold geometry.",
            deepDive: "In iOS 26+, Apple introduced the Liquid Glass design paradigm which reacts with specular refraction, dynamic blur, and interactive morphing across multi-display postures like Book and Tabletop.",
            codeSnippet: """
            GlassEffectContainer(spacing: 24.0) {
                HStack {
                    ViewA().glassEffect()
                    ViewB().glassEffect()
                }
            }
            .postureAdaptive(for: foldableManager.currentPosture)
            """,
            triviaFact: "Liquid Glass containers morph and blend seamlessly as child views get closer together, maintaining 120 FPS through Metal-accelerated fragment shaders.",
            sampleQuestion: QuizQuestion(
                id: "q-glass-1",
                prompt: "Why should sibling views with Liquid Glass be wrapped inside a `GlassEffectContainer`?",
                codeContext: "GlassEffectContainer(spacing: 40) { ... }",
                options: [
                    "To enable smooth morphing and optimize GPU shader batching",
                    "To disable haptics",
                    "To prevent dark mode compatibility",
                    "To turn off blur reflections"
                ],
                correctIndex: 0,
                explanation: "GlassEffectContainer pools shader operations and allows nearby glass elements to physically merge their specular outlines.",
                appleDocReference: "WWDC26: Adopting Liquid Glass in SwiftUI"
            )
        ),
        
        LearningModule(
            id: "apple-silicon-ane",
            title: "Apple Neural Engine (ANE) Pipeline",
            domain: .appleSilicon,
            badgeName: "M-Series Silicon",
            difficulty: "Elite",
            summary: "Explore Unified Memory Architecture (UMA) and how the Apple Neural Engine executes on-device LLMs at ultra-low milliwatt power.",
            deepDive: "UMA shares high-bandwidth LPDDR memory between CPU, GPU, and ANE with zero-copy memory transfers. The 16-core Neural Engine leverages specialized FP16 and INT8 systolic array matrix multiplication.",
            codeSnippet: """
            // Zero-copy CoreML inference on Apple Silicon
            let config = MLModelConfiguration()
            config.computeUnits = .all // Automatically routes matrix operations to ANE
            let predictor = try AppleIntelligenceModel(configuration: config)
            """,
            triviaFact: "Apple's ANE can execute over 38 trillion operations per second (TOPS) while consuming less than 2 watts of battery power.",
            sampleQuestion: QuizQuestion(
                id: "q-ane-1",
                prompt: "What major architectural advantage does Apple's Unified Memory Architecture (UMA) provide for on-device AI?",
                codeContext: "CPU <--- Unified Memory Pool ---> ANE / GPU",
                options: [
                    "Zero-copy data sharing without PCIe bus bottlenecks",
                    "It requires dual motherboards",
                    "It forces all code to run in 32-bit mode",
                    "It requires an external cooling fan"
                ],
                correctIndex: 0,
                explanation: "With UMA, weights and tensors loaded into memory can be directly computed by the Neural Engine without copying across a discrete PCIe bus.",
                appleDocReference: "Apple Silicon Architecture Whitepaper"
            )
        ),
        
        LearningModule(
            id: "apple-heritage",
            title: "From NeXTSTEP to iPhone Duo",
            domain: .ecosystemHeritage,
            badgeName: "Infinite Loop",
            difficulty: "Classic",
            summary: "The evolutionary story of Steve Jobs' NeXTSTEP, Cocoa's 'NS' legacy, the 2014 Swift revolution, and the birth of Apple's foldable devices.",
            deepDive: "NeXTSTEP (1989) brought Objective-C and Interface Builder to computing. When Steve Jobs returned to Apple in 1997, NeXTSTEP became Mac OS X, iOS, and the foundation for today's Swift ecosystem.",
            codeSnippet: """
            // The famous 'NS' prefix stands for NeXTSTEP!
            let date = NSString(string: "WWDC 2014 Swift Launch")
            print("Celebrating Apple developer innovation.")
            """,
            triviaFact: "Chris Lattner started developing the Swift programming language in secret in 2010. It was officially unveiled by Craig Federighi at WWDC 2014 to a standing ovation.",
            sampleQuestion: QuizQuestion(
                id: "q-heritage-1",
                prompt: "What does the historical 'NS' prefix in Cocoa frameworks (like NSString, NSObject) stand for?",
                codeContext: "NSObject, NSString, NSArray",
                options: [
                    "NeXTSTEP",
                    "New System",
                    "Network Security",
                    "National Semiconductor"
                ],
                correctIndex: 0,
                explanation: "The 'NS' prefix originates from Steve Jobs' NeXT Computer and the NeXTSTEP operating system acquired by Apple in 1997.",
                appleDocReference: "Apple History: NeXTSTEP & The Foundation Framework"
            )
        ),
        
        LearningModule(
            id: "foundation-ai",
            title: "Apple FoundationModels Framework",
            domain: .foundationAI,
            badgeName: "Neural Cortex",
            difficulty: "Elite",
            summary: "Harnessing the iOS 26+ FoundationModels framework with @Generable types for structured on-device intelligence.",
            deepDive: "Apple's FoundationModels framework allows developers to prompt the on-device 3B/7B parameter model directly in Swift, returning type-safe structs conforming to `@Generable` with instant validation.",
            codeSnippet: """
            @Generable
            struct CodeReviewSummary {
                let rating: Int
                let potentialBug: String
                let suggestion: String
            }
            
            let model = try SystemFoundationModel()
            let review: CodeReviewSummary = try await model.generate(from: prompt)
            """,
            triviaFact: "Because FoundationModels run locally on device, user telemetry and code snippets never leave the hardware, fulfilling Apple's Private Cloud Compute security promise.",
            sampleQuestion: QuizQuestion(
                id: "q-foundation-1",
                prompt: "What is the primary role of the `@Generable` macro in Apple's FoundationModels framework?",
                codeContext: "@Generable struct StudyPlan { ... }",
                options: [
                    "Guarantees the on-device LLM output matches the exact Swift struct schema",
                    "Compiles Swift directly into Objective-C",
                    "Encrypts files on the flash storage",
                    "Slows down execution to save battery"
                ],
                correctIndex: 0,
                explanation: "@Generable enforces guided decoding at the token level, ensuring the model's generated tokens strictly conform to the Swift type definition.",
                appleDocReference: "Apple Developer: On-Device Generative AI with FoundationModels"
            )
        )
    ]
}

