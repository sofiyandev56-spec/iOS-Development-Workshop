//
//  LightsOutGame.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// An F1 race start. Five red lights come on, then go out after a random wait.
/// Tap as soon as they go out, and your reaction time is measured in milliseconds.
struct LightsOutGame: View {
    private enum Phase {
        case ready, lightsOn, go, result, jumpStart
    }

    @Environment(ProgressStore.self) private var progress
    @State private var phase: Phase = .ready
    @State private var litCount = 0
    @State private var goTime = Date()
    @State private var reactionMs = 0
    @State private var isNewBest = false
    @State private var sequence: Task<Void, Never>?
    @State private var isTouching = false

    var body: some View {
        VStack(spacing: 24) {
            gantry

            Text(progress.best(for: .lightsOut).map { "Personal best: \($0) ms" } ?? "No best time yet")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))
                .contentTransition(.numericText())

            tapArea
        }
        .padding(20)
        .sensoryFeedback(.impact(weight: .heavy), trigger: litCount)
        .sensoryFeedback(trigger: phase) { _, new in
            switch new {
            case .result: .success
            case .jumpStart: .error
            default: nil
            }
        }
        .onDisappear { sequence?.cancel() }
    }

    // MARK: Lights

    private var gantry: some View {
        HStack(spacing: 10) {
            ForEach(0..<5, id: \.self) { column in
                VStack(spacing: 8) {
                    ForEach(0..<2, id: \.self) { _ in
                        let isOn = column < litCount
                        Circle()
                            .fill(isOn ? Color.red : Color.white.opacity(0.08))
                            .frame(width: 34, height: 34)
                            .shadow(color: isOn ? .red : .clear, radius: 12)
                    }
                }
                .padding(8)
                .background(.black.opacity(0.85), in: .rect(cornerRadius: 14))
            }
        }
        .animation(.easeOut(duration: 0.08), value: litCount)
        .padding(.top, 12)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(litCount) of 5 lights on")
    }

    // MARK: Tap area

    private var tapArea: some View {
        VStack(spacing: 10) {
            if phase == .result {
                Text("\(reactionMs) ms")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                Text(rating)
                    .font(.title3.weight(.semibold))
                if isNewBest {
                    NewBestBadge()
                }
            } else {
                Image(systemName: symbol)
                    .font(.system(size: 48, weight: .bold))
                    .contentTransition(.symbolEffect(.replace))
                Text(title)
                    .font(.title.bold())
            }
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.75))
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.regular.tint(areaTint).interactive(), in: .rect(cornerRadius: 32))
        .contentShape(.rect(cornerRadius: 32))
        // Reacts the moment your finger touches down, not when you let go, so the time is fair
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !isTouching else { return }
                    isTouching = true
                    handleTap()
                }
                .onEnded { _ in isTouching = false }
        )
        .animation(.snappy, value: phase)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { handleTap() }
    }

    private var symbol: String {
        switch phase {
        case .ready: "flag.checkered"
        case .lightsOn: "hourglass"
        case .go: "hand.tap.fill"
        case .result: "stopwatch.fill"
        case .jumpStart: "exclamationmark.triangle.fill"
        }
    }

    private var title: String {
        switch phase {
        case .ready: "Tap to Start"
        case .lightsOn: "Wait for it…"
        case .go: "TAP!"
        case .result: ""
        case .jumpStart: "Jump Start!"
        }
    }

    private var subtitle: String {
        switch phase {
        case .ready: "When all five lights go out, tap as fast as you can."
        case .lightsOn: "Don't tap until the lights go out."
        case .go: "Lights out, go go go!"
        case .result: "Tap to race again"
        case .jumpStart: "You tapped before the lights went out. Tap to try again."
        }
    }

    private var areaTint: Color {
        switch phase {
        case .ready: .red.opacity(0.35)
        case .lightsOn: .black.opacity(0.2)
        case .go: .green.opacity(0.55)
        case .result: Topic.f1.tint.opacity(0.35)
        case .jumpStart: .orange.opacity(0.5)
        }
    }

    private var rating: String {
        switch reactionMs {
        case ..<200: "Pole position reflexes! 🏆"
        case ..<250: "Podium pace 🥈"
        case ..<350: "Points finish 🏁"
        case ..<1500: "Keep practising in the sim 🎮"
        default: "Still in the garage? Too slow to count 🛠️"
        }
    }

    // MARK: Actions

    private func handleTap() {
        switch phase {
        case .ready, .result, .jumpStart:
            start()
        case .lightsOn:
            sequence?.cancel()
            litCount = 0
            phase = .jumpStart
        case .go:
            reactionMs = Int(Date().timeIntervalSince(goTime) * 1000)
            // Only real reactions count. Anything slower than 1.5 seconds means you weren't ready.
            isNewBest = reactionMs < 1500 && progress.record(reactionMs, for: .lightsOut)
            phase = .result
        }
    }

    private func start() {
        isNewBest = false
        litCount = 0
        phase = .lightsOn

        sequence = Task {
            // One light every second, like a real F1 start
            for light in 1...5 {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                litCount = light
            }

            // Then a random wait, so you can't guess when they go out
            try? await Task.sleep(for: .seconds(Double.random(in: 0.4...2.5)))
            if Task.isCancelled { return }

            litCount = 0
            goTime = .now
            phase = .go
        }
    }
}

#Preview {
    GameSheet(game: .lightsOut)
        .environment(ProgressStore())
}
