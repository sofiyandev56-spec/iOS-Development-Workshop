//
//  ProgressStore.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import Foundation
import Observation

/// Remembers finished lessons, XP and best game scores, and saves them on the device.
@Observable
final class ProgressStore {
    static let xpPerLesson = 20
    static let xpPerBest = 10
    static let xpPerLevel = 100

    private(set) var completedLessons: Set<String>
    private(set) var bestScores: [String: Int]
    private(set) var xp: Int

    private let defaults: UserDefaults

    private enum Key {
        static let completed = "completedLessons"
        static let scores = "bestScores"
        static let xp = "xp"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completedLessons = Set(defaults.stringArray(forKey: Key.completed) ?? [])
        bestScores = defaults.dictionary(forKey: Key.scores) as? [String: Int] ?? [:]
        xp = defaults.integer(forKey: Key.xp)
    }

    // MARK: Lessons

    func isComplete(_ lesson: Lesson) -> Bool {
        completedLessons.contains(lesson.id)
    }

    func complete(_ lesson: Lesson) {
        guard !isComplete(lesson) else { return }
        completedLessons.insert(lesson.id)
        xp += Self.xpPerLesson
        save()
    }

    func completedCount(in topic: Topic) -> Int {
        topic.lessons.filter(isComplete).count
    }

    /// From 0 (not started) to 1 (every lesson done).
    func progress(for topic: Topic) -> Double {
        let total = topic.lessons.count
        guard total > 0 else { return 0 }
        return Double(completedCount(in: topic)) / Double(total)
    }

    /// The first lesson you haven't finished yet, in course order.
    var nextLesson: Lesson? {
        Curriculum.allLessons.first { !isComplete($0) }
    }

    // MARK: Levels

    var level: Int { xp / Self.xpPerLevel + 1 }

    var levelProgress: Double {
        Double(xp % Self.xpPerLevel) / Double(Self.xpPerLevel)
    }

    var xpToNextLevel: Int { Self.xpPerLevel - xp % Self.xpPerLevel }

    // MARK: Games

    func best(for game: Game) -> Int? {
        bestScores[game.rawValue]
    }

    /// Saves the score if it beats your best. Returns true for a new best.
    @discardableResult
    func record(_ score: Int, for game: Game) -> Bool {
        guard game.isScored, game.lowerIsBetter || score > 0 else { return false }

        let isNewBest: Bool
        if let old = best(for: game) {
            isNewBest = game.lowerIsBetter ? score < old : score > old
        } else {
            isNewBest = true
        }

        if isNewBest {
            bestScores[game.rawValue] = score
            xp += Self.xpPerBest
            save()
        }
        return isNewBest
    }

    // MARK: Saving

    func reset() {
        completedLessons = []
        bestScores = [:]
        xp = 0
        save()
    }

    private func save() {
        defaults.set(Array(completedLessons), forKey: Key.completed)
        defaults.set(bestScores, forKey: Key.scores)
        defaults.set(xp, forKey: Key.xp)
    }
}
