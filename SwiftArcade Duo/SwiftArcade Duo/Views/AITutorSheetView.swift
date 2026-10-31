import SwiftUI
import Combine

/// On-Device Apple Intelligence Tutor Sheet ("Ada")
public struct AITutorSheetView: View {
    @ObservedObject var tutor = AITutorEngine.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var inputText: String = ""
    
    private let promptStarters = [
        "Explain Actor Isolation in Swift 6",
        "Why is UMA faster for AI models?",
        "How do I code for iPhone Duo foldable?",
        "What does 'NS' stand for in Cocoa?"
    ]
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ArcadeTheme.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(ArcadeTheme.neuralGradient)
                            .frame(width: 40, height: 40)
                        Image(systemName: "brain.head.profile")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("Ada • Apple Intelligence")
                                .font(.headline.bold())
                                .foregroundStyle(.white)
                            Circle()
                                .fill(ArcadeTheme.siliconGreen)
                                .frame(width: 7, height: 7)
                        }
                        Text("\(tutor.activeModelName) • \(tutor.tokenGenerationSpeed)")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding()
                .background(Color.white.opacity(0.04))
                
                // Conversation Stream
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(tutor.conversation) { msg in
                                messageBubble(msg)
                            }
                            
                            if tutor.isGenerating {
                                HStack(spacing: 8) {
                                    ProgressView()
                                        .tint(ArcadeTheme.cupertinoCyan)
                                    Text("Neural Engine synthesizing response...")
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundStyle(ArcadeTheme.cupertinoCyan)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                    }
                }
                
                // Prompt Quick Starters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(promptStarters, id: \.self) { prompt in
                            Button {
                                tutor.sendQuery(prompt)
                            } label: {
                                Text(prompt)
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .liquidGlassCard(cornerRadius: 12, tint: ArcadeTheme.neuralViolet)
                            }
                            .springPress()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }
                
                // Query Input Bar
                HStack(spacing: 10) {
                    TextField("Ask Ada anything about Swift & Apple...", text: $inputText)
                        .padding(12)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                    
                    Button {
                        let query = inputText
                        inputText = ""
                        tutor.sendQuery(query)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundStyle(ArcadeTheme.arcadeGradient)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.6))
            }
        }
    }
    
    @ViewBuilder
    private func messageBubble(_ msg: AIMessage) -> some View {
        HStack {
            if msg.sender == .user {
                Spacer()
                Text(msg.text)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(ArcadeTheme.arcadeCrimson)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(ArcadeTheme.cupertinoCyan)
                        Text("Neural Tutor")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(ArcadeTheme.cupertinoCyan)
                    }
                    
                    Text(msg.text)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.95))
                    
                    if let code = msg.codeSnippet {
                        Text(code)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(ArcadeTheme.siliconGreen)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    if let doc = msg.referenceDoc {
                        Label(doc, systemImage: "book.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(12)
                .liquidGlassCard(cornerRadius: 16, tint: ArcadeTheme.neuralViolet)
                Spacer()
            }
        }
    }
}

