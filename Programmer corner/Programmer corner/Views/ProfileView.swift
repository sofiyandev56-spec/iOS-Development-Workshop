//
//  ProfileView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// The Profile tab: level, stats, badges and sign out.
struct ProfileView: View {
    @Environment(ProgressStore.self) private var progress
    @AppStorage("isSignedIn") private var isSignedIn = true
    @State private var confirmReset = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    header
                    stats
                    badges
                    WorkshopCard()
                    actions
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background { AppBackground(tint: .indigo) }
            .navigationTitle("Profile")
        }
    }

    // MARK: Header

    private var header: some View {
        VStack(spacing: 12) {
            Text("KS")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 104, height: 104)
                .background(
                    LinearGradient(colors: [Theme.brandGlow, Theme.brand, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: .circle
                )
                .padding(6)
                .glassEffect(.regular, in: .circle)
                .accessibilityHidden(true)

            Text("King Shaikh")
                .font(.title.bold())

            Text("Level \(progress.level) · \(progress.xp) XP")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .contentTransition(.numericText())

            VStack(spacing: 6) {
                ProgressView(value: progress.levelProgress)
                    .tint(Theme.brand)
                Text("\(progress.xpToNextLevel) XP to Level \(progress.level + 1)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 260)
        }
        .padding(.top, 8)
    }

    // MARK: Stats

    private var stats: some View {
        let topicsDone = Topic.allCases.filter { progress.progress(for: $0) >= 1 }.count
        let reaction = progress.best(for: .lightsOut).map { "\($0) ms" } ?? "–"
        let apples = progress.best(for: .catchTheApple).map(String.init) ?? "–"

        return GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    StatTile(value: "\(progress.completedLessons.count)", label: "Lessons done", symbol: "book.fill", tint: .green)
                    StatTile(value: "\(topicsDone)/\(Topic.allCases.count)", label: "Topics finished", symbol: "checkmark.seal.fill", tint: .blue)
                }
                HStack(spacing: 12) {
                    StatTile(value: reaction, label: "Best reaction", symbol: "flag.checkered", tint: .red)
                    StatTile(value: apples, label: "Most apples", symbol: "apple.logo", tint: .gray)
                }
            }
        }
    }

    // MARK: Badges

    private var badges: some View {
        VStack(alignment: .leading, spacing: 14) {
            let unlocked = achievements.filter(\.isUnlocked).count
            SectionHeader(title: "Badges", subtitle: "\(unlocked) of \(achievements.count) unlocked")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                ForEach(achievements) { badge in
                    BadgeView(badge: badge)
                }
            }
        }
    }

    private var achievements: [Achievement] {
        let topicsStarted = Set(Curriculum.allLessons.filter(progress.isComplete).map(\.topic)).count
        let perfectQuiz = progress.best(for: .typeDetective) == QuizBank.swift.count
            || progress.best(for: .guessOutput) == QuizBank.python.count

        return [
            Achievement(title: "First Steps", detail: "Finish your first lesson", symbol: "figure.walk", color: .green,
                        isUnlocked: !progress.completedLessons.isEmpty),
            Achievement(title: "Swift Starter", detail: "Finish every Swift lesson", symbol: "swift", color: .orange,
                        isUnlocked: progress.progress(for: .swift) >= 1),
            Achievement(title: "Polyglot", detail: "Learn in 4 different topics", symbol: "globe", color: .blue,
                        isUnlocked: topicsStarted >= 4),
            Achievement(title: "Quiz Whiz", detail: "Get a perfect quiz score", symbol: "brain.head.profile", color: .pink,
                        isUnlocked: perfectQuiz),
            Achievement(title: "Bug Squasher", detail: "Find 4 bugs on the first try", symbol: "ladybug.fill", color: .red,
                        isUnlocked: (progress.best(for: .findTheBug) ?? 0) >= 4),
            Achievement(title: "Lightning Reflexes", detail: "React in under 300 ms", symbol: "bolt.fill", color: .yellow,
                        isUnlocked: (progress.best(for: .lightsOut) ?? .max) < 300),
            Achievement(title: "Apple Pro", detail: "Catch 15 apples in one round", symbol: "apple.logo", color: .gray,
                        isUnlocked: (progress.best(for: .catchTheApple) ?? 0) >= 15),
            Achievement(title: "Completionist", detail: "Finish all \(Curriculum.allLessons.count) lessons", symbol: "trophy.fill", color: .purple,
                        isUnlocked: progress.completedLessons.count >= Curriculum.allLessons.count)
        ]
    }

    // MARK: Actions

    private var actions: some View {
        VStack(spacing: 12) {
            Button {
                confirmReset = true
            } label: {
                Label("Reset Progress", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glass)
            .controlSize(.large)
            // Attached to the button so the glass popover points at it
            .confirmationDialog("Reset all progress?", isPresented: $confirmReset, titleVisibility: .visible) {
                Button("Reset Progress", role: .destructive) {
                    withAnimation { progress.reset() }
                }
            } message: {
                Text("This clears your lessons, XP and best scores.")
            }

            Button(role: .destructive) {
                withAnimation { isSignedIn = false }
            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glass)
            .tint(.red)
            .controlSize(.large)
        }
    }
}

private struct Achievement: Identifiable {
    let title: String
    let detail: String
    let symbol: String
    let color: Color
    let isUnlocked: Bool

    var id: String { title }
}

private struct BadgeView: View {
    let badge: Achievement

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: badge.isUnlocked ? badge.symbol : "lock.fill")
                .font(.title2.bold())
                .foregroundStyle(badge.isUnlocked ? .white : .secondary)
                .frame(width: 60, height: 60)
                .background(
                    badge.isUnlocked ? AnyShapeStyle(badge.color.gradient) : AnyShapeStyle(Color(.tertiarySystemFill)),
                    in: .circle
                )

            Text(badge.title)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(badge.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(2, reservesSpace: true)
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
        .opacity(badge.isUnlocked ? 1 : 0.7)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(badge.title), \(badge.isUnlocked ? "unlocked" : "locked"). \(badge.detail)")
    }
}

#Preview {
    ProfileView()
        .environment(ProgressStore())
}
