import SwiftUI
import Combine

/// AI Message representation
public struct AIMessage: Identifiable {
    public let id = UUID()
    public let sender: MessageSender
    public let text: String
    public let timestamp: Date = Date()
    public let codeSnippet: String?
    public let referenceDoc: String?
    
    public enum MessageSender {
        case user
        case neuralTutor
    }
}

/// On-Device Apple Intelligence Mentor Engine ("Ada")
public final class AITutorEngine: ObservableObject {
    public static let shared = AITutorEngine()
    
    @Published public var conversation: [AIMessage] = []
    @Published public var isGenerating: Bool = false
    @Published public var neuralEngineConfidence: Double = 99.2
    @Published public var activeModelName: String = "Apple Intelligence 7B (On-Device ANE)"
    @Published public var tokenGenerationSpeed: String = "118 tokens/sec"
    
    private init() {
        seedInitialGreeting()
    }
    
    private func seedInitialGreeting() {
        conversation = [
            AIMessage(
                sender: .neuralTutor,
                text: "Welcome to SwiftArcade Duo! I'm Ada, your on-device Apple Intelligence mentor. I'm here to analyze your code speedruns, guide your thread isolation in Hinge Hack, and prepare you to impress Apple engineering leads. What topic shall we master today?",
                codeSnippet: "// Tip: Try folding the iPhone Duo to Book Mode to split your workspace!",
                referenceDoc: "WWDC26: Apple Intelligence Integration"
            )
        ]
    }
    
    /// Simulates on-device Neural Engine streaming response
    public func sendQuery(_ query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMsg = AIMessage(sender: .user, text: query, codeSnippet: nil, referenceDoc: nil)
        conversation.append(userMsg)
        
        isGenerating = true
        SoundEngine.shared.playTap()
        
        // Asynchronous neural synthesis
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { [weak self] in
            guard let self = self else { return }
            self.isGenerating = false
            let response = self.generateTutorResponse(for: query)
            self.conversation.append(response)
            SoundEngine.shared.playSelect()
        }
    }
    
    /// Analyzes a game failure and provides immediate targeted AI coaching
    public func diagnoseMistake(concept: String, selectedAnswer: String, correctAnswer: String) {
        let text = "Neural Diagnosis: You selected '\(selectedAnswer)' instead of '\(correctAnswer)' for \(concept). In Apple's strict Swift 6 concurrency model, actor isolation prevents simultaneous mutable state access across task boundaries. Always ensure cross-actor invocations are mediated via `await` or marked `@Sendable`."
        let aiMsg = AIMessage(
            sender: .neuralTutor,
            text: text,
            codeSnippet: "Task { @MainActor in\n    // UI updates guaranteed on main thread\n}",
            referenceDoc: "Swift 6 Concurrency Safety Guide"
        )
        conversation.append(aiMsg)
    }
    
    private func generateTutorResponse(for query: String) -> AIMessage {
        let lower = query.lowercased()
        
        if lower.contains("duo") || lower.contains("fold") || lower.contains("hinge") {
            return AIMessage(
                sender: .neuralTutor,
                text: "The iPhone Duo features a continuous dual-OLED hinge that dynamically notifies your app via geometry changes. When folded to 90° Tabletop mode, you should re-target the bottom pane for precision controls and use the top pane for zero-distraction visual rendering. In SwiftArcade Duo, the Hinge Hack game demonstrates this by routing background threads across the physical fold!",
                codeSnippet: ".postureAdaptive(for: foldableManager.currentPosture)",
                referenceDoc: "Apple Human Interface Guidelines: Foldable Dual Displays"
            )
        } else if lower.contains("actor") || lower.contains("concurrency") || lower.contains("thread") {
            return AIMessage(
                sender: .neuralTutor,
                text: "Actors in Swift 6 are reference types that protect their mutable state via actor isolation. A method on an actor can only execute when no other task is in the actor's synchronization domain. To route back to the UI thread, decorate closures with `@MainActor`.",
                codeSnippet: "@MainActor\nclass ViewModel: ObservableObject {\n    // Bound to UI\n}",
                referenceDoc: "Swift Concurrency: Actor Isolation"
            )
        } else if lower.contains("silicon") || lower.contains("ane") || lower.contains("chip") {
            return AIMessage(
                sender: .neuralTutor,
                text: "Apple Silicon achieves unmatched efficiency through Unified Memory Architecture (UMA). The CPU, GPU, and Apple Neural Engine (ANE) share a single pool of unified memory, allowing multi-billion parameter models to run entirely on-device without memory copying overhead.",
                codeSnippet: "config.computeUnits = .all // Leverages ANE coprocessor",
                referenceDoc: "Apple Silicon Hardware Overview"
            )
        } else {
            return AIMessage(
                sender: .neuralTutor,
                text: "Great question! Apple engineering emphasizes three foundational tenets: strict type and memory safety (Swift 6), hardware-software co-design (Apple Silicon & ANE), and humane, fluid user interactions (Liquid Glass & Foldable Duo ergonomics). Keep pushing your streak in the arcade mini-games to sharpen your intuition!",
                codeSnippet: "print(\"Mastering the Apple Developer Ecosystem 🚀\")",
                referenceDoc: "Apple Developer Academy Curriculum"
            )
        }
    }
}

