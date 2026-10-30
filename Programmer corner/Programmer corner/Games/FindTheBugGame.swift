//
//  FindTheBugGame.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct BugLevel {
    let file: String
    let lines: [String]
    let bugLine: Int
    let hint: String
    let fix: String
}

/// Each level shows some C++. Tap the line with the mistake.
struct FindTheBugGame: View {
    static let levels: [BugLevel] = [
        BugLevel(file: "age.cpp",
                 lines: ["#include <iostream>", "using namespace std;", "", "int main() {", "    int age = 20", "    cout << age;", "    return 0;", "}"],
                 bugLine: 4,
                 hint: "Look at the end of each line.",
                 fix: "Line 5 is missing its semicolon. Every statement in C++ ends with ;"),
        BugLevel(file: "compare.cpp",
                 lines: ["int a = 10;", "if (a = 5) {", "    cout << \"five\";", "}"],
                 bugLine: 1,
                 hint: "How do you compare two values?",
                 fix: "Use == to compare. A single = changes a to 5."),
        BugLevel(file: "array.cpp",
                 lines: ["int nums[3] = {1, 2, 3};", "cout << nums[0];", "cout << nums[1];", "cout << nums[3];"],
                 bugLine: 3,
                 hint: "How many items does nums have?",
                 fix: "nums only has indexes 0, 1 and 2, so nums[3] is outside the array."),
        BugLevel(file: "hello.cpp",
                 lines: ["include <iostream>", "using namespace std;", "", "int main() {", "    cout << \"Hi\";", "}"],
                 bugLine: 0,
                 hint: "Check the very first line.",
                 fix: "It should be #include. The # is missing."),
        BugLevel(file: "loop.cpp",
                 lines: ["for (int i = 0; i < 5; i--) {", "    cout << i;", "}"],
                 bugLine: 0,
                 hint: "Which way is i counting?",
                 fix: "i-- counts down forever. Use i++ to count up to 5."),
        BugLevel(file: "name.cpp",
                 lines: ["string name = 'King';", "cout << name;"],
                 bugLine: 0,
                 hint: "Look closely at the quotes.",
                 fix: "Strings need double quotes: \"King\". Single quotes are for one char, like 'K'.")
    ]

    @Environment(ProgressStore.self) private var progress
    @State private var level = 0
    @State private var score = 0
    @State private var mistakes = 0
    @State private var wrongLine: Int?
    @State private var isSolved = false
    @State private var isFinished = false
    @State private var shakes = 0
    @State private var isNewBest = false

    private var current: BugLevel { Self.levels[level] }
    private let tint = Topic.cpp.tint

    var body: some View {
        ScrollView {
            Group {
                if isFinished {
                    GameResults(score: score, total: Self.levels.count,
                                message: "bugs found on the first try",
                                isNewBest: isNewBest, tint: tint, playAgain: restart)
                } else {
                    board
                }
            }
            .padding(20)
        }
        .scrollBounceBehavior(.basedOnSize)
        .sensoryFeedback(.error, trigger: shakes)
        .sensoryFeedback(.success, trigger: isSolved) { _, new in new }
    }

    private var board: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Level \(level + 1) of \(Self.levels.count)")
                Spacer()
                Label("\(score)", systemImage: "ladybug.fill")
                    .foregroundStyle(.red)
                    .contentTransition(.numericText())
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white.opacity(0.8))

            ProgressView(value: Double(level + (isSolved ? 1 : 0)), total: Double(Self.levels.count))
                .tint(Color(red: 0.3, green: 0.6, blue: 1.0))

            Text("Tap the line with the bug")
                .font(.title2.bold())
                .foregroundStyle(.white)

            editor
                .modifier(ShakeEffect(animatableData: CGFloat(shakes)))

            if isSolved {
                feedback(title: mistakes == 0 ? "First try! 🎉" : "Bug squashed! 🎉", detail: current.fix, color: .green)

                Button(action: nextLevel) {
                    Text(level == Self.levels.count - 1 ? "See Results" : "Next Bug")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .tint(Color(red: 0.2, green: 0.5, blue: 0.95))
                .controlSize(.large)
            } else if wrongLine != nil {
                feedback(title: "Not that line", detail: "Hint: \(current.hint)", color: Color(red: 1.0, green: 0.5, blue: 0.45))
            }
        }
        .animation(.snappy, value: isSolved)
        .animation(.snappy, value: wrongLine)
    }

    private var editor: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                WindowDots()
                Spacer()
                Text(current.file)
                    .font(.caption.monospaced())
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider()
                .overlay(.white.opacity(0.08))

            VStack(alignment: .leading, spacing: 2) {
                ForEach(current.lines.indices, id: \.self) { i in
                    Button {
                        tap(i)
                    } label: {
                        HStack(spacing: 14) {
                            Text("\(i + 1)")
                                .foregroundStyle(.white.opacity(0.35))
                                .frame(width: 20, alignment: .trailing)
                            Text(SyntaxHighlighter.highlight(current.lines[i]))
                            Spacer(minLength: 0)
                        }
                        .font(.system(.callout, design: .monospaced))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(rowColor(i), in: .rect(cornerRadius: 8))
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Line \(i + 1): \(current.lines[i].isEmpty ? "empty" : current.lines[i])")
                }
            }
            .padding(8)
        }
        .background(Theme.codeBackground, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(.white.opacity(0.08)))
    }

    private func feedback(title: String, detail: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(color)
            Text(detail)
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white.opacity(0.08), in: .rect(cornerRadius: 18))
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private func rowColor(_ line: Int) -> Color {
        if isSolved && line == current.bugLine { return .green.opacity(0.3) }
        if wrongLine == line { return .red.opacity(0.3) }
        return .clear
    }

    private func tap(_ line: Int) {
        guard !isSolved else { return }

        if line == current.bugLine {
            isSolved = true
            wrongLine = nil
            if mistakes == 0 {
                score += 1
            }
        } else {
            mistakes += 1
            wrongLine = line
            withAnimation(.default) { shakes += 1 }
        }
    }

    private func nextLevel() {
        if level == Self.levels.count - 1 {
            isNewBest = progress.record(score, for: .findTheBug)
            withAnimation(.smooth) { isFinished = true }
        } else {
            level += 1
            mistakes = 0
            wrongLine = nil
            isSolved = false
        }
    }

    private func restart() {
        withAnimation(.smooth) {
            level = 0
            score = 0
            mistakes = 0
            wrongLine = nil
            isSolved = false
            isNewBest = false
            isFinished = false
        }
    }
}

#Preview {
    GameSheet(game: .findTheBug)
        .environment(ProgressStore())
}
