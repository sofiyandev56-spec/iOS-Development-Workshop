//
//  DefyGravityGame.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// A toy: switch gravity off and the AntiGravity logo floats into space.
struct DefyGravityGame: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var gravityOff = false
    @State private var launches = 0

    var body: some View {
        VStack(spacing: 24) {
            GeometryReader { geo in
                ZStack {
                    StarField(isMoving: gravityOff && !reduceMotion)

                    VStack {
                        Spacer()
                        Capsule()
                            .fill(.white.opacity(0.25))
                            .frame(height: 4)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 24)
                    }

                    floatingLogo
                        .rotationEffect(.degrees(gravityOff ? 360 : 0))
                        .offset(y: gravityOff ? -geo.size.height * 0.25 : geo.size.height / 2 - 86)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .clipShape(.rect(cornerRadius: 28))
            .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(.white.opacity(0.12)))

            VStack(spacing: 6) {
                Text(gravityOff ? "Zero gravity! 🚀" : "Gravity is on 🌍")
                    .font(.title2.bold())
                Text(gravityOff ? "AI agents do the heavy lifting." : "Turn gravity off and watch it fly.")
                    .foregroundStyle(.white.opacity(0.7))
                Text("Launches: \(launches)")
                    .font(.footnote.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(.white.opacity(0.6))
                    .contentTransition(.numericText())
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)

            Button(action: toggleGravity) {
                Label(gravityOff ? "Turn Gravity On" : "Turn Gravity Off",
                      systemImage: gravityOff ? "arrow.down.to.line" : "arrow.up.circle.fill")
                    .font(.headline)
                    .contentTransition(.symbolEffect(.replace))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .tint(Topic.antigravity.tint)
            .controlSize(.large)
        }
        .padding(20)
        .sensoryFeedback(.impact(weight: .medium), trigger: gravityOff)
    }

    private var floatingLogo: some View {
        TopicLogo(topic: .antigravity, size: 96)
            .padding(10)
            .glassEffect(.regular, in: .rect(cornerRadius: 38))
            // Gently bobs up and down while floating
            .phaseAnimator([false, true]) { content, up in
                content
                    .offset(y: gravityOff && !reduceMotion ? (up ? -14 : 0) : 0)
                    .rotationEffect(.degrees(gravityOff && !reduceMotion ? (up ? 4 : -4) : 0))
            } animation: { _ in
                .easeInOut(duration: 1.6)
            }
            .accessibilityLabel(gravityOff ? "Logo floating" : "Logo on the ground")
    }

    private func toggleGravity() {
        withAnimation(.spring(response: 0.9, dampingFraction: gravityOff ? 0.35 : 0.6)) {
            gravityOff.toggle()
        }
        if gravityOff {
            launches += 1
        }
    }
}

/// Little stars that drift upwards in zero gravity.
private struct StarField: View {
    var isMoving: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30, paused: !isMoving)) { context in
            let t = context.date.timeIntervalSinceReferenceDate

            Canvas { graphics, size in
                for i in 0..<45 {
                    let seed = Double(i)
                    let a = sin(seed * 12.9898) * 43758.5453
                    let b = sin(seed * 78.233) * 12345.678
                    let c = sin(seed * 3.7) * 999.1
                    let randomX = a - a.rounded(.down)
                    let randomSpeed = b - b.rounded(.down)
                    let randomSize = c - c.rounded(.down)

                    let travel = size.height + 20
                    let speed = 18 + randomSpeed * 50
                    let y = travel - (t * speed + seed * 61).truncatingRemainder(dividingBy: travel) - 10
                    let radius = 1 + randomSize * 2.2

                    graphics.fill(
                        Path(ellipseIn: CGRect(x: randomX * size.width, y: y, width: radius, height: radius)),
                        with: .color(.white.opacity(0.25 + radius / 6))
                    )
                }
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    GameSheet(game: .defyGravity)
        .environment(ProgressStore())
}
