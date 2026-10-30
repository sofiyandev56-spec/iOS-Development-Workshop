//
//  MainTabView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

/// The Liquid Glass tab bar at the bottom of the app.
struct MainTabView: View {
    enum AppTab: Hashable {
        case learn, arcade, profile, search
    }

    @State private var selection: AppTab = .learn

    var body: some View {
        TabView(selection: $selection) {
            Tab("Learn", systemImage: "book.pages.fill", value: AppTab.learn) {
                homePage()
            }
            Tab("Arcade", systemImage: "gamecontroller.fill", value: AppTab.arcade) {
                ArcadeView()
            }
            Tab("Profile", systemImage: "person.crop.circle.fill", value: AppTab.profile) {
                ProfileView()
            }
            Tab("Search", systemImage: "magnifyingglass", value: AppTab.search, role: .search) {
                SearchView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    MainTabView()
        .environment(ProgressStore())
}
