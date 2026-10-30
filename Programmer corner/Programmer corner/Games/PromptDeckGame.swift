//
//  PromptDeckGame.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI
import UIKit

struct PromptCard {
    let category: String
    let symbol: String
    let text: String
}

/// Swipeable glass cards with prompts you can copy and paste into Claude.
struct PromptDeckGame: View {
    @State private var selection = 0
    @State private var copiedIndex: Int?

    private let tint = Topic.claude.tint

    private let cards: [PromptCard] = [
        PromptCard(category: "Debug", symbol: "ladybug.fill",
                   text: "Here's my error message: [paste it]. Explain what it means in simple words, then show me how to fix it."),
        PromptCard(category: "Explain", symbol: "text.magnifyingglass",
                   text: "Explain this code line by line, like I'm a beginner: [paste your code]"),
        PromptCard(category: "Plan", symbol: "map.fill",
                   text: "I want to build [your app idea] in SwiftUI. Break it into screens and small steps I can build one at a time."),
        PromptCard(category: "Review", symbol: "checkmark.shield.fill",
                   text: "Review my code for bugs and bad habits. Explain each problem before suggesting a fix."),
        PromptCard(category: "Practise", symbol: "brain.head.profile",
                   text: "Quiz me with 5 questions on Swift loops. Wait for my answer before showing the next question."),
        PromptCard(category: "Level Up", symbol: "sparkles",
                   text: "How would an Apple engineer improve this SwiftUI view? Focus on design and accessibility.")
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("Swipe for prompts that make Claude a better coding buddy.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 8)

            TabView(selection: $selection) {
                ForEach(cards.indices, id: \.self) { index in
                    card(cards[index], index: index)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 480)

            Spacer(minLength: 0)
        }
        .padding(.bottom, 12)
        .sensoryFeedback(.selection, trigger: selection)
        .sensoryFeedback(.success, trigger: copiedIndex) { _, new in new != nil }
    }

    private func card(_ card: PromptCard, index: Int) -> some View {
        let isCopied = copiedIndex == index

        return VStack(alignment: .leading, spacing: 20) {
            HStack {
                Label(card.category, systemImage: card.symbol)
                    .font(.headline)
                    .foregroundStyle(tint)
                Spacer()
                TopicLogo(topic: .claude, size: 36)
            }

            Text("“\(card.text)”")
                .font(.title3.weight(.medium))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)

            Button {
                copy(card.text, index: index)
            } label: {
                Label(isCopied ? "Copied!" : "Copy Prompt", systemImage: isCopied ? "checkmark" : "doc.on.doc")
                    .font(.headline)
                    .contentTransition(.symbolEffect(.replace))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .tint(tint)
            .controlSize(.large)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .glassEffect(.regular, in: .rect(cornerRadius: 30))
    }

    private func copy(_ text: String, index: Int) {
        UIPasteboard.general.string = text
        withAnimation { copiedIndex = index }
        Task {
            try? await Task.sleep(for: .seconds(1.6))
            if copiedIndex == index {
                withAnimation { copiedIndex = nil }
            }
        }
    }
}

#Preview {
    GameSheet(game: .promptDeck)
        .environment(ProgressStore())
}
