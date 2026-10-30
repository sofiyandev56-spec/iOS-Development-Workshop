//
//  ApplePage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct ApplePage: View {
    @State private var appleX:CGFloat = 0
    @State private var appleY:CGFloat = 0
    @State private var score:Int = 0

    var body: some View {
        List{
            // Mini game: tap the apple, and it jumps to a random spot
            Section("Mini Game: Catch the Apple")
            {
                VStack(spacing: 12){
                    Text("Score: \(score)")
                        .font(.title2)
                        .fontWeight(.bold)

                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 250)

                        Button {
                            score += 1
                            appleX = CGFloat.random(in: -120...120)
                            appleY = CGFloat.random(in: -90...90)
                        } label: {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 40))
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.plain)
                        .offset(x: appleX, y: appleY)
                        .animation(.easeInOut(duration: 0.2), value: score)
                    }

                    Text(score >= 10 ? "🍏 Apple Pro! You're fast!" : "Tap the apple as fast as you can!")

                    Button("Reset") {
                        score = 0
                        appleX = 0
                        appleY = 0
                    }
                    .buttonStyle(.bordered)
                    .tint(.gray)
                }
                .padding(.vertical)
            }

            Section("Unit-1 Apple Platforms")
            {
                NavigationLink("1.1 The Apple Ecosystem"){
                    ScrollView{
                        VStack{
                            Text("What is the Apple Ecosystem?")
                        }
                    }
                }
                NavigationLink("1.2 iOS and iPadOS"){

                }
                NavigationLink("1.3 macOS"){

                }
                NavigationLink("1.4 watchOS"){

                }
                NavigationLink("1.5 visionOS"){

                }
            }
            Section("Unit-2 Developer Tools")
            {
                NavigationLink("2.1 Xcode"){

                }
                NavigationLink("2.2 SF Symbols"){

                }
                NavigationLink("2.3 TestFlight"){

                }
                NavigationLink("2.4 Publishing on the App Store"){

                }
            }
        }.navigationTitle("Apple Development")
    }
}

#Preview {
    NavigationStack {
        ApplePage()
    }
}
