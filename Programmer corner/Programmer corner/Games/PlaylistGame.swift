//
//  PlaylistGame.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct Song: Identifiable {
    let title: String
    let mood: String
    let duration: Double
    let symbol: String
    let colors: [Color]

    var id: String { title }
}

/// A mini music player with made-up songs for coding. No real audio plays.
struct PlaylistGame: View {
    @State private var current = 0
    @State private var isPlaying = false
    @State private var elapsed: Double = 0

    private let green = Topic.spotify.tint

    private let songs: [Song] = [
        Song(title: "Lo-fi Beats to Code To", mood: "Focus", duration: 200, symbol: "headphones",
             colors: [Color(red: 0.11, green: 0.73, blue: 0.33), Color(red: 0.0, green: 0.45, blue: 0.45)]),
        Song(title: "Debugging at Midnight", mood: "Late night", duration: 245, symbol: "moon.stars.fill",
             colors: [.indigo, .purple]),
        Song(title: "Merge Conflict Blues", mood: "Chill", duration: 168, symbol: "arrow.triangle.merge",
             colors: [.blue, .cyan]),
        Song(title: "Compile Time Chill", mood: "Relax", duration: 192, symbol: "hammer.fill",
             colors: [.orange, .pink]),
        Song(title: "Infinite Loop", mood: "Energy", duration: 222, symbol: "infinity",
             colors: [.mint, .teal])
    ]

    private var song: Song { songs[current] }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                artwork

                VStack(spacing: 4) {
                    Text(song.title)
                        .font(.title2.bold())
                    Text("Programmer corner FM · \(song.mood)")
                        .foregroundStyle(.white.opacity(0.7))
                }
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

                VStack(spacing: 6) {
                    ProgressView(value: elapsed, total: song.duration)
                        .tint(.white)
                    HStack {
                        Text(time(elapsed))
                        Spacer()
                        Text("-" + time(song.duration - elapsed))
                    }
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.white.opacity(0.6))
                }

                controls

                trackList

                Label("Demo player. No real audio plays.", systemImage: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(20)
        }
        .task(id: isPlaying) { await tick() }
        .sensoryFeedback(.selection, trigger: current)
    }

    // MARK: Artwork

    private var artwork: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(LinearGradient(colors: song.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 260, height: 260)
            .overlay {
                Image(systemName: song.symbol)
                    .font(.system(size: 96, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .contentTransition(.symbolEffect(.replace))
            }
            .overlay(alignment: .bottomTrailing) {
                EqualizerBars(isActive: isPlaying)
                    .padding(18)
            }
            .shadow(color: (song.colors.first ?? .clear).opacity(0.6), radius: 30, y: 16)
            .scaleEffect(isPlaying ? 1 : 0.86)
            .animation(.spring(response: 0.5, dampingFraction: 0.65), value: isPlaying)
            .animation(.smooth, value: current)
            .padding(.top, 8)
            .accessibilityHidden(true)
    }

    // MARK: Controls

    private var controls: some View {
        GlassEffectContainer(spacing: 24) {
            HStack(spacing: 24) {
                Button(action: previous) {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .accessibilityLabel("Previous song")

                Button {
                    isPlaying.toggle()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 34, weight: .bold))
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 88, height: 88)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.tint(green.opacity(0.8)).interactive(), in: .circle)
                .accessibilityLabel(isPlaying ? "Pause" : "Play")

                Button(action: next) {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .accessibilityLabel("Next song")
            }
            .foregroundStyle(.white)
        }
    }

    // MARK: Track list

    private var trackList: some View {
        VStack(spacing: 0) {
            ForEach(songs.indices, id: \.self) { index in
                let item = songs[index]
                let isCurrent = index == current

                Button {
                    play(index)
                } label: {
                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(colors: item.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 46, height: 46)
                            .overlay {
                                Image(systemName: item.symbol)
                                    .foregroundStyle(.white)
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.body.weight(isCurrent ? .bold : .regular))
                                .foregroundStyle(isCurrent ? green : .white)
                            Text(item.mood)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                        }

                        Spacer()

                        if isCurrent && isPlaying {
                            Image(systemName: "waveform")
                                .foregroundStyle(green)
                                .symbolEffect(.variableColor.iterative, isActive: true)
                        } else {
                            Text(time(item.duration))
                                .font(.caption)
                                .monospacedDigit()
                                .foregroundStyle(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(item.title), \(item.mood)")
                .accessibilityAddTraits(isCurrent ? .isSelected : [])
            }
        }
        .padding(.vertical, 6)
        .background(.white.opacity(0.06), in: .rect(cornerRadius: 22))
    }

    // MARK: Playback

    private func play(_ index: Int) {
        if index == current {
            isPlaying.toggle()
        } else {
            current = index
            elapsed = 0
            isPlaying = true
        }
    }

    private func next() {
        current = (current + 1) % songs.count
        elapsed = 0
    }

    private func previous() {
        if elapsed > 3 {
            elapsed = 0
        } else {
            current = (current - 1 + songs.count) % songs.count
            elapsed = 0
        }
    }

    /// Moves the progress bar forward while a song is "playing".
    private func tick() async {
        guard isPlaying else { return }

        while !Task.isCancelled {
            try? await Task.sleep(for: .milliseconds(250))
            if Task.isCancelled { return }
            elapsed += 0.25
            if elapsed >= song.duration {
                next()
            }
        }
    }

    private func time(_ seconds: Double) -> String {
        let total = max(0, Int(seconds))
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}

/// Bouncing bars that show music is playing.
private struct EqualizerBars: View {
    var isActive: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.12, paused: !isActive)) { context in
            let t = context.date.timeIntervalSinceReferenceDate

            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<5, id: \.self) { bar in
                    Capsule()
                        .fill(.white)
                        .frame(width: 5, height: isActive ? 8 + 22 * abs(sin(t * 3 + Double(bar) * 1.3)) : 6)
                }
            }
            .frame(height: 30, alignment: .bottom)
            .animation(.easeInOut(duration: 0.12), value: t)
        }
    }
}

#Preview {
    GameSheet(game: .codingPlaylist)
        .environment(ProgressStore())
}
