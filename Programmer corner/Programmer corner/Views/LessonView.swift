//
//  LessonView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// Reading screen for one lesson, with a code sample and a glass "Mark as Complete" bar.
struct LessonView: View {
    let lesson: Lesson

    @Environment(ProgressStore.self) private var progress
    @State private var showXP = false

    private var topic: Topic { lesson.topic }
    private var isDone: Bool { progress.isComplete(lesson) }

    private var nextLesson: Lesson? {
        let lessons = topic.lessons
        guard let index = lessons.firstIndex(of: lesson), index + 1 < lessons.count else { return nil }
        return lessons[index + 1]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    TopicLogo(topic: topic, size: 30)
                    Text("\(topic.title) · Lesson \(lesson.number)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(topic.tint)
                }

                Text(lesson.title)
                    .font(.largeTitle.bold())

                Label("\(lesson.minutes) min read", systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(lesson.summary)
                    .font(.title3)
                    .lineSpacing(4)

                if let code = lesson.code {
                    CodeBlock(code: code, language: topic.codeLanguage)
                }
            }
            .padding(20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background { AppBackground(tint: topic.tint) }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { bottomBar }
        .sensoryFeedback(.success, trigger: isDone) { _, new in new }
    }

    private var bottomBar: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: markComplete) {
                    Label(isDone ? "Completed" : "Mark as Complete",
                          systemImage: isDone ? "checkmark.circle.fill" : "circle")
                        .font(.headline)
                        .contentTransition(.symbolEffect(.replace))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .tint(isDone ? .green : topic.tint)
                .controlSize(.large)
                .allowsHitTesting(!isDone)
                .overlay(alignment: .top) {
                    if showXP {
                        Text("+\(ProgressStore.xpPerLesson) XP")
                            .font(.headline.bold())
                            .foregroundStyle(.orange)
                            .offset(y: -40)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }

                if let nextLesson {
                    NavigationLink(value: nextLesson) {
                        Image(systemName: "arrow.right")
                            .font(.headline)
                            .padding(.horizontal, 6)
                    }
                    .buttonStyle(.glass)
                    .controlSize(.large)
                    .accessibilityLabel("Next lesson: \(nextLesson.title)")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }

    private func markComplete() {
        withAnimation(.bouncy) {
            progress.complete(lesson)
            showXP = true
        }
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            withAnimation(.smooth) { showXP = false }
        }
    }
}

extension View {
    /// Lets any NavigationStack open a lesson.
    func lessonDestination() -> some View {
        navigationDestination(for: Lesson.self) { lesson in
            LessonView(lesson: lesson)
        }
    }
}

#Preview {
    NavigationStack {
        LessonView(lesson: Topic.swift.lessons[3])
    }
    .environment(ProgressStore())
}
