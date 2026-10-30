//
//  Topic.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// One course on the home screen, like Swift or Python.
enum Topic: String, CaseIterable, Identifiable, Hashable {
    case swift, antigravity, claude, python, cpp, apple, f1, spotify

    var id: String { rawValue }

    var title: String {
        switch self {
        case .swift: "Swift"
        case .antigravity: "AntiGravity"
        case .claude: "Claude"
        case .python: "Python"
        case .cpp: "C++"
        case .apple: "Apple"
        case .f1: "F1"
        case .spotify: "Spotify"
        }
    }

    var tagline: String {
        switch self {
        case .swift: "Apple's fast, modern language"
        case .antigravity: "Build apps with AI agents"
        case .claude: "Your AI pair programmer"
        case .python: "Simple, powerful, everywhere"
        case .cpp: "Speed and full control"
        case .apple: "Platforms, tools and design"
        case .f1: "Engineering at 350 km/h"
        case .spotify: "The tech behind the music"
        }
    }

    var image: ImageResource {
        switch self {
        case .swift: .swift
        case .antigravity: .anti
        case .claude: .claude
        case .python: .python
        case .cpp: .CPP
        case .apple: .apple
        case .f1: .F_1
        case .spotify: .spotify
        }
    }

    /// The brand colour used for this topic's cards, buttons and games.
    var tint: Color {
        switch self {
        case .swift: Color(red: 0.98, green: 0.36, blue: 0.20)
        case .antigravity: Color(red: 0.24, green: 0.47, blue: 0.96)
        case .claude: Color(red: 0.85, green: 0.47, blue: 0.34)
        case .python: Color(red: 0.22, green: 0.46, blue: 0.67)
        case .cpp: Color(red: 0.00, green: 0.35, blue: 0.61)
        case .apple: Color(red: 0.36, green: 0.37, blue: 0.42)
        case .f1: Color(red: 0.88, green: 0.02, blue: 0.00)
        case .spotify: Color(red: 0.11, green: 0.73, blue: 0.33)
        }
    }

    var gradient: LinearGradient {
        LinearGradient(
            colors: [tint, tint.mix(with: .black, by: 0.45)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// The label shown on top of code samples in this topic.
    var codeLanguage: String {
        switch self {
        case .python: "Python"
        case .cpp: "C++"
        case .claude, .antigravity: "Prompt"
        case .apple: "SwiftUI"
        default: "Swift"
        }
    }

    var game: Game {
        switch self {
        case .swift: .typeDetective
        case .antigravity: .defyGravity
        case .claude: .promptDeck
        case .python: .guessOutput
        case .cpp: .findTheBug
        case .apple: .catchTheApple
        case .f1: .lightsOut
        case .spotify: .codingPlaylist
        }
    }

    var units: [CourseUnit] { Curriculum.units(for: self) }

    var lessons: [Lesson] { units.flatMap(\.lessons) }
}

/// A group of lessons inside a topic, like "Unit 1".
struct CourseUnit: Identifiable {
    let number: Int
    let title: String
    let lessons: [Lesson]

    var id: Int { number }
}

/// A single lesson with a short explanation and an optional code sample.
struct Lesson: Identifiable, Hashable {
    let topic: Topic
    let number: String
    let title: String
    let minutes: Int
    let summary: String
    let code: String?

    var id: String { "\(topic.rawValue)-\(number)" }

    init(_ topic: Topic, _ number: String, _ title: String, minutes: Int, summary: String, code: String? = nil) {
        self.topic = topic
        self.number = number
        self.title = title
        self.minutes = minutes
        self.summary = summary
        self.code = code
    }
}
