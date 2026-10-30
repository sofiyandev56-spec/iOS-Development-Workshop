//
//  ContentView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 29/10/26.
//

import SwiftUI

/// Shows the login screen, or the main app once you're signed in.
struct ContentView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false

    var body: some View {
        ZStack {
            if isSignedIn {
                MainTabView()
                    .transition(.opacity.combined(with: .scale(scale: 1.04)))
            } else {
                LoginView()
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
        .animation(.smooth(duration: 0.6), value: isSignedIn)
    }
}

#Preview {
    ContentView()
        .environment(ProgressStore())
}
