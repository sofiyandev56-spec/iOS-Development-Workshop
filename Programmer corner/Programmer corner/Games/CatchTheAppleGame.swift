//
//  CatchTheAppleGame.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// Tap the glass apple before it jumps away. 20 seconds per round.
struct CatchTheAppleGame: View {
    private let roundLength = 20

    @Environment(ProgressStore.self) private var progress
    @State private var score = 0
    @State private var timeLeft = 20
    @State private var isRunning = false
    @State private var isFinished = false
    @State private var isNewBest = false
    // Where the apple is, from 0 to 1 across and down the play area
    @State private var position = CGPoint(x: 0.5, y: 0.5)

    /// The apple gets smaller as your score goes up.
    private var appleSize: CGFloat { max(52, 96 - CGFloat(score) * 2) }

    var body: some View {
        VStack(spacing: 20) {
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    statPill(title: "Score", value: "\(score)", symbol: "apple.logo")
                    statPill(title: "Time", value: "\(timeLeft)s", symbol: "timer")
                    statPill(title: "Best", value: progress.best(for: .catchTheApple).map(String.init) ?? "–", symbol: "crown.fill")
                }
            }

            arena

            Button(action: start) {
                Label(isFinished ? "Play Again" : "Start", systemImage: isFinished ? "arrow.counterclockwise" : "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .tint(.red)
            .controlSize(.large)
            .opacity(isRunning ? 0 : 1)
            .disabled(isRunning)
        }
        .padding(20)
        .task(id: isRunning) { await runClock() }
        .sensoryFeedback(.impact(weight: .light), trigger: score)
        .sensoryFeedback(.success, trigger: isFinished) { _, new in new }
        .onDisappear { isRunning = false }
    }

    private var arena: some View {
        GeometryReader { geo in
            let size = appleSize

            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(.white.opacity(0.05))
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(.white.opacity(0.12))

                if isRunning {
                    Button(action: catchApple) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: size * 0.42, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: size, height: size)
                            .glassEffect(.regular.tint(.red.opacity(0.45)).interactive(), in: .circle)
                    }
                    .buttonStyle(.plain)
                    .position(
                        x: size / 2 + position.x * (geo.size.width - size),
                        y: size / 2 + position.y * (geo.size.height - size)
                    )
                    .transition(.scale.combined(with: .opacity))
                    .accessibilityLabel("Apple")
                } else {
                    VStack(spacing: 12) {
                        if isFinished {
                            Text("\(score)")
                                .font(.system(size: 80, weight: .bold, design: .rounded))
                            Text(score == 1 ? "apple caught" : "apples caught")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.8))
                            if isNewBest {
                                NewBestBadge()
                            }
                        } else {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 60))
                            Text("Tap the apple as many times as you can in \(roundLength) seconds.")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(30)
                }
            }
        }
    }

    private func statPill(title: String, value: String, symbol: String) -> some View {
        VStack(spacing: 4) {
            Label(title, systemImage: symbol)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(.title2.bold())
                .monospacedDigit()
                .foregroundStyle(.white)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .glassEffect(.regular, in: .rect(cornerRadius: 18))
        .accessibilityElement(children: .combine)
    }

    private func start() {
        score = 0
        timeLeft = roundLength
        isNewBest = false
        isFinished = false
        position = CGPoint(x: 0.5, y: 0.5)
        withAnimation(.snappy) { isRunning = true }
    }

    private func catchApple() {
        score += 1
        withAnimation(.snappy(duration: 0.25)) {
            position = CGPoint(x: .random(in: 0...1), y: .random(in: 0...1))
        }
    }

    /// Counts down once a second while the round is running.
    private func runClock() async {
        guard isRunning else { return }

        while timeLeft > 0 {
            try? await Task.sleep(for: .seconds(1))
            if Task.isCancelled { return }
            withAnimation { timeLeft -= 1 }
        }

        isNewBest = progress.record(score, for: .catchTheApple)
        withAnimation(.snappy) {
            isRunning = false
            isFinished = true
        }
    }
}

#Preview {
    GameSheet(game: .catchTheApple)
        .environment(ProgressStore())
}
