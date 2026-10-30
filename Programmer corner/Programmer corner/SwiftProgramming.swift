//
//  SwiftProgramming.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct SwiftProgramming: View {
    var body: some View {
        List{
            Section("Unit-1 Introduction to Swift")
            {
                NavigationLink("1.1 History of Swift"){
                    ScrollView{
                        VStack{
                            Text("What is Swift Programming?")
                        }
                    }
                }
                NavigationLink("1.2 Constant Variables and Data Types"){
                    
                }
                NavigationLink("1.3 Operators and Control Flow"){
                    
                }
                NavigationLink("1.4 Functions"){
                    
                }
                NavigationLink("1.5 Loops"){
                    
                }
                NavigationLink("1.6 Structure"){
                    
                }
            }
            Section("Unit-2 iOS Development")
            {
                NavigationLink("2.1 Intro to XCode"){
                    VStack{
                        Text("What is Swift Programming?")
                    }
                }
                NavigationLink("2.2 InterFace Building"){
                    
                }
                NavigationLink("2.3 Navigation Control"){
                    
                }
                NavigationLink("2.4 Layout Contenors"){
                    
                }
            }
        }.navigationTitle("Swift Programming")
    }
}

#Preview {
    NavigationStack {
        SwiftProgramming()
    }
}
