//
//  ArcadeView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// The Arcade tab: every mini game in one place.
struct ArcadeView: View {
    @Environment(ProgressStore.self) private var progress
    @State private var activeGame: Game?

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    featured

                    SectionHeader(title: "All Games", subtitle: "Play to learn and earn XP")

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(Game.allCases) { game in
                            Button {
                                activeGame = game
                            } label: {
                                GameTile(game: game, best: progress.best(for: game))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .background { AppBackground(tint: .purple) }
            .navigationTitle("Arcade")
            .navigationSubtitle("\(Game.allCases.count) ways to learn by playing")
            .sheet(item: $activeGame) { game in
                GameSheet(game: game)
            }
        }
    }

    private var featured: some View {
        let game = Game.lightsOut

        return Button {
            activeGame = game
        } label: {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color(red: 0.85, green: 0.05, blue: 0.05), Color(red: 0.25, green: 0.0, blue: 0.0), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { _ in
                        Circle()
                            .fill(.red)
                            .frame(width: 20, height: 20)
                            .shadow(color: .red, radius: 8)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 6) {
                    Text("FEATURED")
                        .font(.caption.weight(.bold))
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(game.title)
                        .font(.largeTitle.bold())
                    Text(game.blurb)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.leading)
                    Text(game.bestText(progress.best(for: game)))
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glassEffect(.regular, in: .capsule)
                        .padding(.top, 6)
                }
                .foregroundStyle(.white)
                .padding(20)
            }
            .frame(height: 240)
            .clipShape(.rect(cornerRadius: 28))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Featured game: \(game.title)")
        .accessibilityHint(game.blurb)
    }
}

private struct GameTile: View {
    let game: Game
    let best: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: game.symbol)
                    .font(.title2.bold())
                    .frame(width: 52, height: 52)
                    .glassEffect(.regular, in: .rect(cornerRadius: 16))
                Spacer()
                TopicLogo(topic: game.topic, size: 30)
            }

            Spacer(minLength: 8)

            Text(game.title)
                .font(.headline)
            Text(game.bestText(best))
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
        .foregroundStyle(.white)
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 170, alignment: .topLeading)
        .background(game.topic.gradient, in: .rect(cornerRadius: 24))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(game.title), \(game.topic.title)")
        .accessibilityValue(game.bestText(best))
    }
}

#Preview {
    ArcadeView()
        .environment(ProgressStore())
}
