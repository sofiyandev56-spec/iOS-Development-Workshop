//
//  homePage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 29/10/26.
//

import SwiftUI

struct homePage: View {
    @State private var GotoSwift:Bool = false
    @State private var GotoAnti:Bool = false
    @State private var GotoClaude:Bool = false
    @State private var GotoPython:Bool = false
    @State private var GotoCpp:Bool = false
    @State private var GotoApple:Bool = false
    @State private var GotoSpotify:Bool = false
    @State private var GotoF1:Bool = false
    var body: some View {
        ScrollView {
            VStack {
                Button {
                    GotoSwift = true
                } label: {
                    VStack {
                        Image(.swift)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("Swift")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
                Button {
                    GotoAnti = true
                } label: {
                    VStack {
                        Image(.anti)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("AntiGravity")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
                Button {
                    GotoClaude = true
                } label: {
                    VStack {
                        Image(.claude)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("Claude")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.orange.opacity(0.3))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
                Button {
                    GotoPython = true
                } label: {
                    VStack {
                        Image(.python)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("Python")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
                Button {
                    GotoCpp = true
                } label: {
                    VStack {
                        Image(.CPP)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("CPP")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.mint.opacity(0.2))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
                Button {
                    GotoApple = true
                } label: {
                    VStack {
                        Image(.apple)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("Apple")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
                Button {
                    GotoF1 = true
                } label: {
                    VStack {
                        Image(.F_1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("F1")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
                Button {
                    GotoSpotify = true
                } label: {
                    VStack {
                        Image(.spotify)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text("Spotify")
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 420, height: 150)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(19)
                    .shadow(radius: 125)
                }
            }
        }.navigationTitle("KING SHAIKH")
        .navigationDestination(isPresented: $GotoSwift)
        {
            SwiftProgramming()
        }
        .navigationDestination(isPresented: $GotoAnti)
        {
            AntiGravityPage()
        }
        .navigationDestination(isPresented: $GotoClaude)
        {
            ClaudePage()
        }
        .navigationDestination(isPresented: $GotoPython)
        {
            PythonPage()
        }
        .navigationDestination(isPresented: $GotoCpp)
        {
            CppPage()
        }
        .navigationDestination(isPresented: $GotoApple)
        {
            ApplePage()
        }
        .navigationDestination(isPresented: $GotoF1)
        {
            F1Page()
        }
        .navigationDestination(isPresented: $GotoSpotify)
        {
            SpotifyPage()
        }
    }
}

#Preview {
    NavigationStack {
        homePage()
    }
}
