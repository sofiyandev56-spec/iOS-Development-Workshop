//
//  LoginView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage: String?
    @State private var failedAttempts = 0
    @State private var isSigningIn = false
    @FocusState private var focusedField: Field?

    private enum Field { case email, password }

    // Sample login for the demo (not a real account)
    static let demoEmail = "test@example.com"
    static let demoPassword = "password123"

    var body: some View {
        ZStack {
            LoginBackdrop()

            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 32) {
                        header
                        form
                        footer
                    }
                    .padding(24)
                    .frame(maxWidth: 440)
                    .frame(maxWidth: .infinity, minHeight: geo.size.height)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .environment(\.colorScheme, .dark)
        .sensoryFeedback(.error, trigger: failedAttempts)
        .sensoryFeedback(.success, trigger: isSigningIn) { _, new in new }
    }

    // MARK: Header

    private var header: some View {
        VStack(spacing: 14) {
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 88, height: 88)
                .glassEffect(.regular.tint(Theme.brand.opacity(0.5)), in: .circle)
                .symbolEffect(.bounce, value: isSigningIn)
                .accessibilityHidden(true)

            Text("KING SHAIKH")
                .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                .tracking(2)
                .foregroundStyle(.white)

            Text("PRECISION. PRESTIGE. POWER.")
                .font(.caption.weight(.semibold))
                .tracking(3)
                .foregroundStyle(.white.opacity(0.7))

            Text("Sign in to Programmer corner")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
                .padding(.top, 6)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: Form

    private var form: some View {
        VStack(spacing: 16) {
            GlassEffectContainer(spacing: 14) {
                VStack(spacing: 14) {
                    field(icon: "envelope.fill") {
                        TextField("Email", text: $email, prompt: Text("Email").foregroundStyle(.white.opacity(0.55)))
                            .keyboardType(.emailAddress)
                            .textContentType(.username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }
                    }

                    field(icon: "lock.fill") {
                        Group {
                            if showPassword {
                                TextField("Password", text: $password, prompt: Text("Password").foregroundStyle(.white.opacity(0.55)))
                            } else {
                                SecureField("Password", text: $password, prompt: Text("Password").foregroundStyle(.white.opacity(0.55)))
                            }
                        }
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit(signIn)

                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .contentTransition(.symbolEffect(.replace))
                                .foregroundStyle(.white.opacity(0.7))
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(showPassword ? "Hide password" : "Show password")
                    }
                }
            }
            .modifier(ShakeEffect(animatableData: CGFloat(failedAttempts)))

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(Color(red: 1.0, green: 0.62, blue: 0.58))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Button(action: signIn) {
                HStack(spacing: 10) {
                    if isSigningIn {
                        ProgressView()
                            .tint(.white)
                    }
                    Text(isSigningIn ? "Signing In…" : "Sign In")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.glassProminent)
            .tint(Theme.brand)
            .controlSize(.large)
            .disabled(isSigningIn)

            Button(action: useDemoAccount) {
                Label("Use Demo Account", systemImage: "person.badge.key.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.glass)
            .tint(.white)
            .controlSize(.large)
            .disabled(isSigningIn)
        }
    }

    private func field<Content: View>(icon: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.white.opacity(0.7))
                .frame(width: 22)
                .accessibilityHidden(true)
            content()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .frame(height: 58)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))
    }

    // MARK: Footer

    private var footer: some View {
        Text("\(Image(systemName: "graduationcap.fill"))  iOS Development Workshop\nApple Authorised Training Center for Education")
            .font(.caption2)
            .lineSpacing(3)
            .foregroundStyle(.white.opacity(0.6))
            .multilineTextAlignment(.center)
    }

    // MARK: Actions

    private func signIn() {
        let enteredEmail = email.trimmingCharacters(in: .whitespaces).lowercased()

        guard !enteredEmail.isEmpty, !password.isEmpty else {
            fail("Enter your email and password.")
            return
        }
        guard enteredEmail == Self.demoEmail, password == Self.demoPassword else {
            fail("That email or password isn't right.")
            return
        }

        focusedField = nil
        withAnimation { errorMessage = nil }
        isSigningIn = true

        Task {
            try? await Task.sleep(for: .milliseconds(800))
            withAnimation(.smooth(duration: 0.6)) { isSignedIn = true }
        }
    }

    private func fail(_ message: String) {
        withAnimation(.default) { failedAttempts += 1 }
        withAnimation(.snappy) { errorMessage = message }
    }

    private func useDemoAccount() {
        email = Self.demoEmail
        password = Self.demoPassword
        signIn()
    }
}

/// Moving colours with the topic logos floating and blurred behind the login form.
private struct LoginBackdrop: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let logos: [(topic: Topic, x: CGFloat, y: CGFloat, size: CGFloat)] = [
        (.swift, 0.15, 0.09, 62), (.python, 0.85, 0.10, 56),
        (.cpp, 0.07, 0.40, 48), (.claude, 0.93, 0.36, 50),
        (.antigravity, 0.10, 0.66, 46), (.apple, 0.91, 0.70, 44),
        (.f1, 0.18, 0.92, 56), (.spotify, 0.82, 0.93, 58)
    ]

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30, paused: reduceMotion)) { context in
            let t = context.date.timeIntervalSinceReferenceDate

            GeometryReader { geo in
                ZStack {
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: [
                            [0, 0], [0.5, 0], [1, 0],
                            [0, 0.5],
                            SIMD2<Float>(Float(0.5 + 0.18 * sin(t * 0.35)), Float(0.5 + 0.14 * cos(t * 0.3))),
                            [1, 0.5],
                            [0, 1], [0.5, 1], [1, 1]
                        ],
                        colors: [
                            Color(red: 0.02, green: 0.20, blue: 0.24), Color(red: 0.00, green: 0.45, blue: 0.42), Color(red: 0.05, green: 0.10, blue: 0.25),
                            Color(red: 0.10, green: 0.18, blue: 0.40), Color(red: 0.00, green: 0.60, blue: 0.53), Color(red: 0.25, green: 0.12, blue: 0.40),
                            Color(red: 0.01, green: 0.03, blue: 0.08), Color(red: 0.05, green: 0.15, blue: 0.22), Color(red: 0.02, green: 0.05, blue: 0.12)
                        ]
                    )

                    ForEach(logos.indices, id: \.self) { i in
                        let logo = logos[i]
                        let phase = Double(i)
                        TopicLogo(topic: logo.topic, size: logo.size)
                            .blur(radius: 2.5)
                            .opacity(0.55)
                            .rotationEffect(.degrees(sin(t * 0.3 + phase) * 8))
                            .position(
                                x: logo.x * geo.size.width + sin(t * 0.4 + phase * 1.7) * 10,
                                y: logo.y * geo.size.height + cos(t * 0.35 + phase) * 14
                            )
                    }
                }
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

#Preview {
    LoginView()
}
