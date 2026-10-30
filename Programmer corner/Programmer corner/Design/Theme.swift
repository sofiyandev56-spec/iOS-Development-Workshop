//
//  Theme.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// The app's main colours.
enum Theme {
    static let brand = Color(red: 0.00, green: 0.54, blue: 0.48)
    static let brandGlow = Color(red: 0.25, green: 0.85, blue: 0.75)
}

/// Soft coloured glow behind the main screens, so Liquid Glass has something to reflect.
struct AppBackground: View {
    var tint: Color = Theme.brand

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.45], [0.55, 0.35], [1, 0.4],
                    [0, 1], [0.5, 1], [1, 1]
                ],
                colors: [
                    tint.opacity(0.45), tint.opacity(0.25), Theme.brandGlow.opacity(0.30),
                    tint.opacity(0.12), tint.opacity(0), tint.opacity(0.08),
                    tint.opacity(0), tint.opacity(0), tint.opacity(0)
                ]
            )
        }
        .ignoresSafeArea()
    }
}

/// Dark, rich background for the game screens.
struct GameBackground: View {
    let tint: Color

    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.6, 0.4], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ],
            colors: [
                tint.mix(with: .black, by: 0.25), tint.mix(with: .black, by: 0.5), .black,
                tint.mix(with: .black, by: 0.6), tint.mix(with: .black, by: 0.78), .black,
                .black, tint.mix(with: .black, by: 0.85), .black
            ]
        )
        .ignoresSafeArea()
    }
}

/// A topic's logo on a white rounded tile, so dark logos (Apple, F1) stay visible everywhere.
struct TopicLogo: View {
    let topic: Topic
    var size: CGFloat = 56

    var body: some View {
        Image(topic.image)
            .resizable()
            .scaledToFit()
            .padding(size * 0.16)
            .frame(width: size, height: size)
            .background(.white, in: .rect(cornerRadius: size * 0.28))
            .shadow(color: .black.opacity(0.15), radius: size * 0.08, y: size * 0.04)
            .accessibilityHidden(true)
    }
}

/// A small glass tile that shows one number, like XP or level.
struct StatTile: View {
    let value: String
    let label: String
    let symbol: String
    var tint: Color = Theme.brand

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: symbol)
                .font(.headline)
                .foregroundStyle(tint)
            Text(value)
                .font(.title2.bold())
                .monospacedDigit()
                .contentTransition(.numericText())
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
        .accessibilityElement(children: .combine)
    }
}

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.title2.bold())
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

/// Shakes a view side to side, like a wrong password on iPhone.
struct ShakeEffect: GeometryEffect {
    var travel: CGFloat = 10
    var shakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travel * sin(animatableData * .pi * shakes * 2), y: 0))
    }
}
