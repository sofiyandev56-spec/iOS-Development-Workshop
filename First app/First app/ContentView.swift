//
//  ContentView.swift
//  First app
//
//  Created by Developer Sofiyan on 29/10/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            Text("Welcome To The Jungle")
                .font(.system(size:70))
                .fontWeight(.bold)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.blue, .pink, .orange, .teal],
                        startPoint: .leading,
                        endPoint: .trailing
                )
            )
            
            HStack{
                
                Button{
                    
                }
                label: {
                    Text("Play")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .frame(width:90, height:30)
                        .background(.black)
                        .cornerRadius(14)
                }
                Button{
                    
                }
                label: {
                    Text("Exit")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .frame(width:90, height:30)
                        .background(.black)
                        .cornerRadius(14)
                }
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
