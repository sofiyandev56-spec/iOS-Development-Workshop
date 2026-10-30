//
//  SpotifyPage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct SpotifyPage: View {
    @State private var isPlaying:Bool = false
    @State private var song:String = "Lo-fi Beats to Code To"

    var body: some View {
        List{
            // A mini music player at the top of the page
            Section
            {
                VStack(spacing: 12){
                    Image(.spotify)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

                    Text(isPlaying ? "Now Playing" : "Paused")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    Text(song)
                        .font(.title3)
                        .fontWeight(.bold)

                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.green)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            // Tap a song to "play" it in the player above
            Section("Coding Playlist")
            {
                Button {
                    song = "Lo-fi Beats to Code To"
                    isPlaying = true
                } label: {
                    HStack{
                        Image(systemName: "music.note")
                            .foregroundStyle(.green)
                        Text("Lo-fi Beats to Code To")
                            .foregroundStyle(.primary)
                        Spacer()
                        Text("3:20")
                            .foregroundStyle(.gray)
                    }
                }
                Button {
                    song = "Debugging at Midnight"
                    isPlaying = true
                } label: {
                    HStack{
                        Image(systemName: "music.note")
                            .foregroundStyle(.green)
                        Text("Debugging at Midnight")
                            .foregroundStyle(.primary)
                        Spacer()
                        Text("4:05")
                            .foregroundStyle(.gray)
                    }
                }
                Button {
                    song = "Merge Conflict Blues"
                    isPlaying = true
                } label: {
                    HStack{
                        Image(systemName: "music.note")
                            .foregroundStyle(.green)
                        Text("Merge Conflict Blues")
                            .foregroundStyle(.primary)
                        Spacer()
                        Text("2:48")
                            .foregroundStyle(.gray)
                    }
                }
                Button {
                    song = "Infinite Loop"
                    isPlaying = true
                } label: {
                    HStack{
                        Image(systemName: "music.note")
                            .foregroundStyle(.green)
                        Text("Infinite Loop")
                            .foregroundStyle(.primary)
                        Spacer()
                        Text("∞")
                            .foregroundStyle(.gray)
                    }
                }
            }

            Section("Unit-1 How Spotify Works")
            {
                NavigationLink("1.1 How Music Streaming Works"){
                    ScrollView{
                        VStack{
                            Text("How does a song reach your phone?")
                        }
                    }
                }
                NavigationLink("1.2 How Spotify Picks Songs for You"){

                }
                NavigationLink("1.3 The Languages Behind Spotify"){

                }
                NavigationLink("1.4 Build Your Own Music Player in Swift"){

                }
            }
        }.navigationTitle("Spotify")
    }
}

#Preview {
    NavigationStack {
        SpotifyPage()
    }
}
