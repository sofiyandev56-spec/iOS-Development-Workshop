//
//  AntiGravityPage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct AntiGravityPage: View {
    @State private var gravityOff:Bool = false
    @State private var launches:Int = 0

    var body: some View {
        List{
            // Mini game: switch gravity off and watch the logo float
            Section("Mini Game: Defy Gravity")
            {
                VStack(spacing: 16){
                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.1))
                            .frame(height: 250)

                        Image(.anti)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(gravityOff ? 360 : 0))
                            .offset(y: gravityOff ? -80 : 80)
                            .animation(.spring(response: 0.8, dampingFraction: 0.4), value: gravityOff)
                    }

                    Text(gravityOff ? "Wheee! Floating 🚀" : "Stuck on the ground 🌍")
                        .font(.headline)

                    Button(gravityOff ? "Turn Gravity Back On" : "Turn Off Gravity") {
                        gravityOff.toggle()
                        if gravityOff {
                            launches += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    Text("Launches: \(launches)")
                        .foregroundStyle(.gray)
                }
                .padding(.vertical)
            }

            Section("Unit-1 Getting Started")
            {
                NavigationLink("1.1 What is AntiGravity?"){
                    ScrollView{
                        VStack{
                            Text("What is AntiGravity?")
                        }
                    }
                }
                NavigationLink("1.2 Installing and Setup"){

                }
                NavigationLink("1.3 A Tour of the Editor"){

                }
                NavigationLink("1.4 Your First Project"){

                }
            }
            Section("Unit-2 Working with AI Agents")
            {
                NavigationLink("2.1 What is an AI Agent?"){

                }
                NavigationLink("2.2 Giving Clear Tasks"){

                }
                NavigationLink("2.3 Reviewing the Agent's Changes"){

                }
                NavigationLink("2.4 Testing Your App"){

                }
            }
        }.navigationTitle("AntiGravity")
    }
}

#Preview {
    NavigationStack {
        AntiGravityPage()
    }
}
