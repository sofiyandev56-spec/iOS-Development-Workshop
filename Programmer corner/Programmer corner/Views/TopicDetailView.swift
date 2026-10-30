//
//  TopicDetailView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// One topic's page: its mini game and every lesson, grouped by unit.
struct TopicDetailView: View {
    let topic: Topic

    @Environment(ProgressStore.self) private var progress
    @State private var isPlaying = false

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                hero
                gameCard
                ForEach(topic.units) { unit in
                    unitSection(unit)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background { AppBackground(tint: topic.tint) }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPlaying) {
            GameSheet(game: topic.game)
        }
    }

    private var hero: some View {
        let done = progress.completedCount(in: topic)
        let total = topic.lessons.count

        return VStack(spacing: 12) {
            TopicLogo(topic: topic, size: 96)
                .padding(10)
                .glassEffect(.regular, in: .rect(cornerRadius: 38))

            Text(topic.title)
                .font(.largeTitle.bold())
            Text(topic.tagline)
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ProgressView(value: Double(done), total: Double(max(total, 1)))
                    .tint(topic.tint)
                    .frame(maxWidth: 160)
                Text("\(done) of \(total) lessons")
                    .font(.subheadline)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }

    private var gameCard: some View {
        Button {
            isPlaying = true
        } label: {
            HStack(spacing: 16) {
                Image(systemName: topic.game.symbol)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(topic.tint.gradient, in: .rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 3) {
                    Text(topic.game.kindLabel.uppercased())
                        .font(.caption2.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(topic.tint)
                    Text(topic.game.title)
                        .font(.headline)
                    Text(topic.game.blurb)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                Image(systemName: "play.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(topic.tint, in: .circle)
            }
            .padding(16)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 26))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Play \(topic.game.title)")
        .accessibilityHint(topic.game.blurb)
    }

    private func unitSection(_ unit: CourseUnit) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("UNIT \(unit.number)")
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(topic.tint)
                Text(unit.title)
                    .font(.title3.bold())
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                ForEach(unit.lessons) { lesson in
                    LessonRow(lesson: lesson, isDone: progress.isComplete(lesson))
                    if lesson.id != unit.lessons.last?.id {
                        Divider()
                            .padding(.leading, 68)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 22))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct LessonRow: View {
    let lesson: Lesson
    let isDone: Bool

    var body: some View {
        NavigationLink(value: lesson) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isDone ? lesson.topic.tint : lesson.topic.tint.opacity(0.15))
                    if isDone {
                        Image(systemName: "checkmark")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                    } else {
                        Text(lesson.number)
                            .font(.caption.bold())
                            .monospacedDigit()
                            .foregroundStyle(lesson.topic.tint)
                    }
                }
                .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(lesson.title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Text("\(lesson.minutes) min read")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityValue(isDone ? "Completed" : "Not started")
    }
}

#Preview {
    NavigationStack {
        TopicDetailView(topic: .swift)
            .lessonDestination()
    }
    .environment(ProgressStore())
}
