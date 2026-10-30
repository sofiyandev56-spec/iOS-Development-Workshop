//
//  Programmer_cornerApp.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 29/10/26.
//

import SwiftUI

@main
struct Programmer_cornerApp: App {
    // One shared place that remembers lessons, XP and best scores
    @State private var progress = ProgressStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(progress)
                .tint(Theme.brand)
        }
    }
}
