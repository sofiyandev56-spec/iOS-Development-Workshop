//
//  PythonPage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct PythonPage: View {
    @State private var question:Int = 0
    @State private var score:Int = 0
    @State private var message:String = "Pick an answer"

    // Each question has some code, 3 choices and the right answer
    let codes:[String] = [
        "print(2 ** 3)",
        "print(\"Hi\" * 3)",
        "print(len(\"Python\"))",
        "print(10 // 3)"
    ]
    let options:[[String]] = [
        ["6", "8", "9"],
        ["Hi3", "HiHiHi", "Error"],
        ["5", "6", "7"],
        ["3", "3.33", "4"]
    ]
    let answers:[String] = ["8", "HiHiHi", "6", "3"]

    var body: some View {
        List{
            // Mini game: read the code and guess what it prints
            Section("Mini Game: Guess the Output")
            {
                VStack(spacing: 12){
                    Image(.python)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)

                    Text("What does this print?")
                        .font(.headline)

                    Text(codes[question])
                        .font(.system(.title3, design: .monospaced))
                        .foregroundStyle(.green)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(12)

                    HStack{
                        ForEach(options[question], id: \.self) { option in
                            Button(option) {
                                check(option)
                            }
                            .buttonStyle(.bordered)
                            .tint(.blue)
                        }
                    }

                    Text(message)

                    Text("Score: \(score)")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Unit-1 Python Basics")
            {
                NavigationLink("1.1 What is Python?"){
                    ScrollView{
                        VStack{
                            Text("What is Python Programming?")
                        }
                    }
                }
                NavigationLink("1.2 Variables and Data Types"){

                }
                NavigationLink("1.3 Operators"){

                }
                NavigationLink("1.4 If and Else"){

                }
                NavigationLink("1.5 Loops"){

                }
                NavigationLink("1.6 Functions"){

                }
            }
            Section("Unit-2 Going Further")
            {
                NavigationLink("2.1 Lists and Dictionaries"){

                }
                NavigationLink("2.2 Reading and Writing Files"){

                }
                NavigationLink("2.3 Classes and Objects"){

                }
                NavigationLink("2.4 Libraries with pip"){

                }
            }
        }.navigationTitle("Python Programming")
    }

    // Checks the answer, then moves to the next question
    private func check(_ option:String) {
        if option == answers[question] {
            score += 1
            message = "Correct! 🎉"
        }
        else{
            message = "Oops! It was \(answers[question])"
        }

        if question == codes.count - 1 {
            question = 0
        }
        else{
            question += 1
        }
    }
}

#Preview {
    NavigationStack {
        PythonPage()
    }
}
