//
//  GameSheet.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// Full-screen sheet that hosts any mini game.
struct GameSheet: View {
    let game: Game

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            game.view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background { GameBackground(tint: game.topic.tint) }
                .navigationTitle(game.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .close) {
                            dismiss()
                        }
                        .tint(.white)
                    }
                }
        }
        .environment(\.colorScheme, .dark)
    }
}

/// Little glass badge shown when you beat your best score.
struct NewBestBadge: View {
    var body: some View {
        Label("New best! +\(ProgressStore.xpPerBest) XP", systemImage: "sparkles")
            .font(.subheadline.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .glassEffect(.regular.tint(.yellow.opacity(0.35)), in: .capsule)
            .transition(.scale.combined(with: .opacity))
    }
}

/// The end-of-round screen shared by the quiz and bug games.
struct GameResults: View {
    let score: Int
    let total: Int
    let message: String
    let isNewBest: Bool
    let tint: Color
    let playAgain: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: score == total ? "trophy.fill" : "star.circle.fill")
                .font(.system(size: 76))
                .foregroundStyle(.yellow.gradient)
                .symbolEffect(.bounce, value: score)
                .padding(.top, 40)
                .accessibilityHidden(true)

            Text("\(score) / \(total)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(message)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.center)

            if isNewBest {
                NewBestBadge()
            }

            Button(action: playAgain) {
                Label("Play Again", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .tint(tint)
            .controlSize(.large)
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            GameSheet(game: .lightsOut)
        }
        .environment(ProgressStore())
}
