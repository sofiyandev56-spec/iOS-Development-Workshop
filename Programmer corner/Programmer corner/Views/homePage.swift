//
//  homePage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 29/10/26.
//

import SwiftUI

/// The Learn tab: continue where you left off, your stats, and every topic.
struct homePage: View {
    @Environment(ProgressStore.self) private var progress
    @Namespace private var zoom

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    if let next = progress.nextLesson {
                        ContinueCard(lesson: next, topicProgress: progress.progress(for: next.topic))
                    }

                    GlassEffectContainer(spacing: 12) {
                        HStack(spacing: 12) {
                            StatTile(value: "\(progress.xp)", label: "XP earned", symbol: "bolt.fill", tint: .orange)
                            StatTile(value: "\(progress.completedLessons.count)/\(Curriculum.allLessons.count)", label: "Lessons", symbol: "checkmark.seal.fill", tint: .green)
                            StatTile(value: "\(progress.level)", label: "Level", symbol: "star.fill", tint: .yellow)
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "Topics", subtitle: "\(Topic.allCases.count) courses to explore")

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(Topic.allCases) { topic in
                                NavigationLink(value: topic) {
                                    TopicCard(
                                        topic: topic,
                                        completed: progress.completedCount(in: topic),
                                        progress: progress.progress(for: topic)
                                    )
                                }
                                .buttonStyle(.plain)
                                .matchedTransitionSource(id: topic, in: zoom) { source in
                                    source.clipShape(.rect(cornerRadius: 24))
                                }
                            }
                        }
                    }

                    WorkshopCard()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .background { AppBackground() }
            .navigationTitle("KING SHAIKH")
            .navigationSubtitle(greeting)
            .navigationDestination(for: Topic.self) { topic in
                TopicDetailView(topic: topic)
                    .navigationTransition(.zoom(sourceID: topic, in: zoom))
            }
            .lessonDestination()
        }
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning · Level \(progress.level)"
        case 12..<17: "Good afternoon · Level \(progress.level)"
        default: "Good evening · Level \(progress.level)"
        }
    }
}

/// Big card that takes you straight to your next lesson.
private struct ContinueCard: View {
    let lesson: Lesson
    let topicProgress: Double

    var body: some View {
        NavigationLink(value: lesson) {
            VStack(alignment: .leading, spacing: 12) {
                Label("Continue learning", systemImage: "sparkles")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))

                Text(lesson.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)

                Text("\(lesson.topic.title) · Lesson \(lesson.number) · \(lesson.minutes) min")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))

                HStack(spacing: 14) {
                    ProgressView(value: topicProgress)
                        .tint(.white)
                    Text("Resume")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 9)
                        .glassEffect(.regular.interactive(), in: .capsule)
                }
                .padding(.top, 4)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ZStack(alignment: .topTrailing) {
                    lesson.topic.gradient
                    TopicLogo(topic: lesson.topic, size: 120)
                        .opacity(0.18)
                        .rotationEffect(.degrees(-12))
                        .offset(x: 30, y: -10)
                }
            }
            .clipShape(.rect(cornerRadius: 28))
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens your next lesson")
    }
}

/// One coloured topic card on the home grid.
private struct TopicCard: View {
    let topic: Topic
    let completed: Int
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                TopicLogo(topic: topic, size: 52)
                Spacer()
                Label(progress >= 1 ? "Done" : "\(completed)/\(topic.lessons.count)",
                      systemImage: progress >= 1 ? "checkmark.seal.fill" : "book.closed.fill")
                    .font(.caption2.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .glassEffect(.regular, in: .capsule)
            }

            Spacer(minLength: 12)

            Text(topic.title)
                .font(.title3.bold())
            Text(topic.tagline)
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(2, reservesSpace: true)

            ProgressView(value: progress)
                .tint(.white)
        }
        .foregroundStyle(.white)
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
        .background(topic.gradient, in: .rect(cornerRadius: 24))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(topic.title). \(topic.tagline)")
        .accessibilityValue("\(completed) of \(topic.lessons.count) lessons done")
    }
}

/// Credits the workshop where this app was made.
struct WorkshopCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "graduationcap.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(Theme.brand.gradient, in: .rect(cornerRadius: 16))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text("iOS Development Workshop")
                    .font(.headline)
                Text("Made during a 2-day workshop with Apple Authorised Mentors at our college's Apple Authorised Training Center for Education.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 22))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    homePage()
        .environment(ProgressStore())
}
