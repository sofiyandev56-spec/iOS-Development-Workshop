//
//  CodeBlock.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI
import UIKit

/// A dark code editor card with Xcode-style colours and a copy button.
struct CodeBlock: View {
    let code: String
    var language: String = ""
    var showsCopyButton = true

    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                WindowDots()
                Spacer()
                Text(language)
                    .font(.caption.monospaced())
                    .foregroundStyle(.white.opacity(0.5))
                if showsCopyButton {
                    Button(action: copy) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .contentTransition(.symbolEffect(.replace))
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(copied ? "Copied" : "Copy code")
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)

            Divider()
                .overlay(.white.opacity(0.08))

            ScrollView(.horizontal, showsIndicators: false) {
                Text(SyntaxHighlighter.highlight(code))
                    .font(.system(.callout, design: .monospaced))
                    .lineSpacing(4)
                    .textSelection(.enabled)
                    .padding(14)
            }
        }
        .background(Theme.codeBackground, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(.white.opacity(0.08)))
        .environment(\.colorScheme, .dark)
        .sensoryFeedback(.success, trigger: copied) { _, new in new }
    }

    private func copy() {
        UIPasteboard.general.string = code
        copied = true
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            copied = false
        }
    }
}

/// The red, yellow and green dots from a Mac window.
struct WindowDots: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Color(red: 1.00, green: 0.37, blue: 0.34))
            Circle().fill(Color(red: 1.00, green: 0.74, blue: 0.18))
            Circle().fill(Color(red: 0.16, green: 0.79, blue: 0.25))
        }
        .frame(width: 42, height: 10)
        .accessibilityHidden(true)
    }
}

extension Theme {
    static let codeBackground = Color(red: 0.10, green: 0.11, blue: 0.14)
}

/// Colours keywords, strings, numbers and comments like Xcode's dark theme.
enum SyntaxHighlighter {
    private static let plain = Color(white: 0.92)
    private static let keyword = Color(red: 0.99, green: 0.37, blue: 0.64)
    private static let type = Color(red: 0.36, green: 0.85, blue: 1.00)
    private static let string = Color(red: 0.99, green: 0.42, blue: 0.36)
    private static let number = Color(red: 0.82, green: 0.75, blue: 0.41)
    private static let comment = Color(red: 0.45, green: 0.50, blue: 0.56)

    private static let keywords: Set<String> = [
        "let", "var", "func", "if", "else", "for", "in", "while", "return", "struct", "class",
        "enum", "import", "true", "false", "nil", "def", "elif", "True", "False", "None",
        "int", "double", "char", "void", "bool", "using", "namespace", "public", "private",
        "try", "some", "switch", "case", "static", "self", "const", "auto"
    ]

    private static let types: Set<String> = [
        "String", "Int", "Double", "Bool", "View", "Text", "VStack", "HStack", "ZStack",
        "Image", "Button", "NavigationStack", "NavigationLink", "LazyVGrid", "GridItem",
        "ForEach", "Date", "AVAudioPlayer", "Bundle", "Student", "Car", "ContentView",
        "string", "cout", "cin", "print", "range", "len"
    ]

    static func highlight(_ code: String) -> AttributedString {
        var text = AttributedString(code)
        text.foregroundColor = plain

        paint(#"[#@]?[A-Za-z_][A-Za-z0-9_]*"#, in: code, on: &text) { word in
            if keywords.contains(word) || word.hasPrefix("#") || word.hasPrefix("@") { return keyword }
            if types.contains(word) { return type }
            return nil
        }
        paint(#"\b[0-9]+(\.[0-9]+)?\b"#, in: code, on: &text) { _ in number }
        paint(#""[^"\n]*"|'[^'\n]*'"#, in: code, on: &text) { _ in string }
        paint(#"//.*|# .*"#, in: code, on: &text) { _ in comment }

        return text
    }

    private static func paint(_ pattern: String, in code: String, on text: inout AttributedString, color: (String) -> Color?) {
        guard let regex = try? Regex(pattern) else { return }
        for match in code.matches(of: regex) {
            guard let color = color(String(code[match.range])),
                  let range = Range(match.range, in: text) else { continue }
            text[range].foregroundColor = color
        }
    }
}
