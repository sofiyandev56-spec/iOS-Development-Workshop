//
//  Game.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// The mini games, one for each topic.
enum Game: String, CaseIterable, Identifiable {
    case typeDetective, defyGravity, promptDeck, guessOutput, findTheBug, catchTheApple, lightsOut, codingPlaylist

    var id: String { rawValue }

    var topic: Topic {
        switch self {
        case .typeDetective: .swift
        case .defyGravity: .antigravity
        case .promptDeck: .claude
        case .guessOutput: .python
        case .findTheBug: .cpp
        case .catchTheApple: .apple
        case .lightsOut: .f1
        case .codingPlaylist: .spotify
        }
    }

    var title: String {
        switch self {
        case .typeDetective: "Type Detective"
        case .defyGravity: "Defy Gravity"
        case .promptDeck: "Prompt Deck"
        case .guessOutput: "Guess the Output"
        case .findTheBug: "Find the Bug"
        case .catchTheApple: "Catch the Apple"
        case .lightsOut: "Lights Out"
        case .codingPlaylist: "Coding Playlist"
        }
    }

    var symbol: String {
        switch self {
        case .typeDetective: "magnifyingglass"
        case .defyGravity: "arrow.up.circle.fill"
        case .promptDeck: "text.bubble.fill"
        case .guessOutput: "terminal.fill"
        case .findTheBug: "ladybug.fill"
        case .catchTheApple: "apple.logo"
        case .lightsOut: "flag.checkered"
        case .codingPlaylist: "music.note"
        }
    }

    var blurb: String {
        switch self {
        case .typeDetective: "Guess the type Swift gives each value."
        case .defyGravity: "Switch gravity off and watch the logo fly."
        case .promptDeck: "Swipe through prompts that make Claude a better coding buddy."
        case .guessOutput: "Read a line of Python and pick what it prints."
        case .findTheBug: "Tap the line of C++ that has the mistake."
        case .catchTheApple: "Tap the apple as many times as you can in 20 seconds."
        case .lightsOut: "Test your reaction time like an F1 driver at the race start."
        case .codingPlaylist: "A mini music player with songs for coding."
        }
    }

    /// Short label shown on cards, like "Mini Game" or "Toy".
    var kindLabel: String {
        switch self {
        case .defyGravity: "Toy"
        case .promptDeck: "Prompt Cards"
        case .codingPlaylist: "Music Player"
        default: "Mini Game"
        }
    }

    /// Games that keep a best score.
    var isScored: Bool {
        switch self {
        case .defyGravity, .promptDeck, .codingPlaylist: false
        default: true
        }
    }

    /// For Lights Out a smaller time is better. For every other game, higher is better.
    var lowerIsBetter: Bool { self == .lightsOut }

    func bestText(_ best: Int?) -> String {
        guard isScored else { return kindLabel }
        guard let best else { return "Not played yet" }

        switch self {
        case .typeDetective: return "Best \(best)/\(QuizBank.swift.count)"
        case .guessOutput: return "Best \(best)/\(QuizBank.python.count)"
        case .findTheBug: return "Best \(best)/\(FindTheBugGame.levels.count) bugs"
        case .catchTheApple: return "Best \(best) apples"
        case .lightsOut: return "Best \(best) ms"
        default: return kindLabel
        }
    }

    /// The screen that plays this game.
    @ViewBuilder
    var view: some View {
        switch self {
        case .typeDetective:
            QuizGame(game: self, prompt: "What type does Swift give this?", questions: QuizBank.swift)
        case .guessOutput:
            QuizGame(game: self, prompt: "What does this print?", questions: QuizBank.python)
        case .defyGravity:
            DefyGravityGame()
        case .promptDeck:
            PromptDeckGame()
        case .findTheBug:
            FindTheBugGame()
        case .catchTheApple:
            CatchTheAppleGame()
        case .lightsOut:
            LightsOutGame()
        case .codingPlaylist:
            PlaylistGame()
        }
    }
}
