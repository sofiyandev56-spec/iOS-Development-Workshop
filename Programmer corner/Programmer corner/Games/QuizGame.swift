//
//  QuizGame.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct QuizQuestion {
    let code: String
    let options: [String]
    let answer: String
    let explanation: String
}

/// The questions for Type Detective (Swift) and Guess the Output (Python).
enum QuizBank {
    static let swift: [QuizQuestion] = [
        QuizQuestion(code: "let year = 2014", options: ["Int", "Double", "String", "Bool"], answer: "Int",
                     explanation: "Whole numbers are Int. 2014 is the year Swift was announced."),
        QuizQuestion(code: "let pi = 3.14", options: ["Int", "Double", "String", "Bool"], answer: "Double",
                     explanation: "Numbers with a decimal point are Double."),
        QuizQuestion(code: #"let name = "Swift""#, options: ["Int", "Double", "String", "Bool"], answer: "String",
                     explanation: "Text inside double quotes is a String."),
        QuizQuestion(code: "let isFun = true", options: ["Int", "Double", "String", "Bool"], answer: "Bool",
                     explanation: "true and false are Bool values."),
        QuizQuestion(code: "let total = 10 / 4", options: ["Int", "Double", "String", "Bool"], answer: "Int",
                     explanation: "Dividing two Ints gives an Int, so 10 / 4 is 2, not 2.5."),
        QuizQuestion(code: "let passed = 80 > 50", options: ["Int", "Double", "String", "Bool"], answer: "Bool",
                     explanation: "A comparison like > always gives true or false, so it's a Bool."),
        QuizQuestion(code: "let price = 9.99 * 2", options: ["Int", "Double", "String", "Bool"], answer: "Double",
                     explanation: "9.99 is a Double, so the result is a Double too."),
        QuizQuestion(code: #"let rocket = "🚀""#, options: ["Int", "Double", "String", "Bool"], answer: "String",
                     explanation: "Emoji are text, so this is a String.")
    ]

    static let python: [QuizQuestion] = [
        QuizQuestion(code: "print(2 ** 3)", options: ["6", "8", "9"], answer: "8",
                     explanation: "** means \"to the power of\": 2 × 2 × 2 = 8."),
        QuizQuestion(code: #"print("Hi" * 3)"#, options: ["Hi3", "HiHiHi", "Error"], answer: "HiHiHi",
                     explanation: "Multiplying a string repeats it."),
        QuizQuestion(code: #"print(len("Python"))"#, options: ["5", "6", "7"], answer: "6",
                     explanation: "len counts the characters: P-y-t-h-o-n."),
        QuizQuestion(code: "print(10 // 3)", options: ["3", "3.33", "4"], answer: "3",
                     explanation: "// divides and drops the decimal part."),
        QuizQuestion(code: "print(10 % 3)", options: ["0", "1", "3"], answer: "1",
                     explanation: "% gives the remainder: 10 = 3 × 3 + 1."),
        QuizQuestion(code: "print([1, 2, 3][-1])", options: ["1", "3", "Error"], answer: "3",
                     explanation: "-1 means the last item in a list."),
        QuizQuestion(code: #"print("swift".upper())"#, options: ["swift", "Swift", "SWIFT"], answer: "SWIFT",
                     explanation: "upper() turns every letter into a capital.")
    ]
}

/// A multiple-choice quiz: read some code and pick the right answer.
struct QuizGame: View {
    let game: Game
    let prompt: String
    let questions: [QuizQuestion]

    @Environment(ProgressStore.self) private var progress
    @State private var index = 0
    @State private var score = 0
    @State private var picked: String?
    @State private var isFinished = false
    @State private var isNewBest = false

    private var question: QuizQuestion { questions[index] }
    private var tint: Color { game.topic.tint }

    var body: some View {
        ScrollView {
            Group {
                if isFinished {
                    GameResults(score: score, total: questions.count, message: resultMessage,
                                isNewBest: isNewBest, tint: tint, playAgain: restart)
                } else {
                    questionView
                }
            }
            .padding(20)
        }
        .scrollBounceBehavior(.basedOnSize)
        .sensoryFeedback(trigger: picked) { _, newValue in
            guard let newValue else { return nil }
            return newValue == question.answer ? .success : .error
        }
    }

    private var questionView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Question \(index + 1) of \(questions.count)")
                Spacer()
                Label("\(score)", systemImage: "star.fill")
                    .foregroundStyle(.yellow)
                    .contentTransition(.numericText())
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white.opacity(0.8))

            ProgressView(value: Double(index + (picked == nil ? 0 : 1)), total: Double(questions.count))
                .tint(tint)

            Text(prompt)
                .font(.title2.bold())
                .foregroundStyle(.white)

            CodeBlock(code: question.code, language: game.topic.codeLanguage, showsCopyButton: false)

            GlassEffectContainer(spacing: 12) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(question.options, id: \.self) { option in
                        Button {
                            pick(option)
                        } label: {
                            Text(option)
                                .font(.headline.monospaced())
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 58)
                                .glassEffect(glass(for: option), in: .rect(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                        .allowsHitTesting(picked == nil)
                    }
                }
            }

            if let picked {
                let isRight = picked == question.answer

                VStack(alignment: .leading, spacing: 8) {
                    Label(isRight ? "Correct!" : "Not quite, it's \(question.answer)",
                          systemImage: isRight ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(isRight ? .green : Color(red: 1.0, green: 0.5, blue: 0.45))
                    Text(question.explanation)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.white.opacity(0.08), in: .rect(cornerRadius: 18))
                .transition(.opacity.combined(with: .move(edge: .bottom)))

                Button(action: next) {
                    Text(index == questions.count - 1 ? "See Results" : "Next Question")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .tint(tint)
                .controlSize(.large)
            }
        }
        .animation(.snappy, value: picked)
        .animation(.smooth, value: index)
    }

    /// Green for the right answer, red for a wrong pick, plain glass before you answer.
    private func glass(for option: String) -> Glass {
        guard let picked else { return .regular.interactive() }
        if option == question.answer { return .regular.tint(.green.opacity(0.7)) }
        if option == picked { return .regular.tint(.red.opacity(0.7)) }
        return .regular
    }

    private var resultMessage: String {
        switch Double(score) / Double(questions.count) {
        case 1: "Perfect score! 🏆"
        case 0.7...: "Great work! 🎉"
        case 0.4...: "Nice try, keep practising 💪"
        default: "Read the lessons and try again 📚"
        }
    }

    private func pick(_ option: String) {
        picked = option
        if option == question.answer {
            score += 1
        }
    }

    private func next() {
        if index == questions.count - 1 {
            isNewBest = progress.record(score, for: game)
            withAnimation(.smooth) { isFinished = true }
        } else {
            picked = nil
            index += 1
        }
    }

    private func restart() {
        withAnimation(.smooth) {
            index = 0
            score = 0
            picked = nil
            isNewBest = false
            isFinished = false
        }
    }
}

#Preview {
    GameSheet(game: .guessOutput)
        .environment(ProgressStore())
}
