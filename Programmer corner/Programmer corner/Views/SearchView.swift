//
//  SearchView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// The Search tab: find any lesson by title, topic or code.
struct SearchView: View {
    @State private var query = ""

    private var results: [Lesson] {
        Curriculum.allLessons.filter { lesson in
            lesson.title.localizedStandardContains(query)
                || lesson.summary.localizedStandardContains(query)
                || lesson.topic.title.localizedStandardContains(query)
                || (lesson.code?.localizedStandardContains(query) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if query.isEmpty {
                    Section("Browse Topics") {
                        ForEach(Topic.allCases) { topic in
                            NavigationLink(value: topic) {
                                HStack(spacing: 14) {
                                    TopicLogo(topic: topic, size: 40)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(topic.title)
                                            .font(.body.weight(.semibold))
                                        Text(topic.tagline)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Section("\(results.count) lessons") {
                        ForEach(results) { lesson in
                            NavigationLink(value: lesson) {
                                HStack(spacing: 14) {
                                    TopicLogo(topic: lesson.topic, size: 36)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(lesson.title)
                                            .font(.body.weight(.medium))
                                        Text("\(lesson.topic.title) · Lesson \(lesson.number)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .overlay {
                if !query.isEmpty && results.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $query, prompt: "Lessons, topics or code")
            .navigationDestination(for: Topic.self) { topic in
                TopicDetailView(topic: topic)
            }
            .lessonDestination()
        }
    }
}

#Preview {
    SearchView()
        .environment(ProgressStore())
}
