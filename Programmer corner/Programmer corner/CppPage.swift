//
//  CppPage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct CppPage: View {
    @State private var level:Int = 0
    @State private var score:Int = 0
    @State private var message:String = "Tap the line with the bug 🐞"

    // Each level has 3 lines of code, and one of them has a bug
    let codes:[[String]] = [
        ["int age = 20;", "cout << age", "return 0;"],
        ["int a = 10;", "if (a = 5) {", "cout << \"five\";"],
        ["int nums[3] = {1, 2, 3};", "cout << nums[0];", "cout << nums[3];"],
        ["include <iostream>", "using namespace std;", "int main() {"]
    ]
    let bugLines:[Int] = [1, 1, 2, 0]
    let hints:[String] = [
        "Every line needs a ; at the end.",
        "Use == to compare. A single = changes the value.",
        "nums has 3 items, so they are nums[0], nums[1] and nums[2].",
        "#include needs the # at the start."
    ]

    var body: some View {
        List{
            // Mini game: find the line with the bug
            Section("Mini Game: Find the Bug")
            {
                VStack(spacing: 12){
                    Image(.CPP)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)

                    Text("Level \(level + 1)")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8){
                        ForEach(0..<3, id: \.self) { line in
                            Button {
                                check(line)
                            } label: {
                                Text(codes[level][line])
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundStyle(.green)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)

                    Text(message)
                        .multilineTextAlignment(.center)

                    Text("Bugs squashed: \(score)")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Unit-1 Introduction to C++")
            {
                NavigationLink("1.1 History of C++"){
                    ScrollView{
                        VStack{
                            Text("What is C++ Programming?")
                        }
                    }
                }
                NavigationLink("1.2 Variables and Data Types"){

                }
                NavigationLink("1.3 Input and Output (cin, cout)"){

                }
                NavigationLink("1.4 Conditions and Loops"){

                }
                NavigationLink("1.5 Functions"){

                }
                NavigationLink("1.6 Arrays"){

                }
            }
            Section("Unit-2 Object Oriented C++")
            {
                NavigationLink("2.1 Classes and Objects"){

                }
                NavigationLink("2.2 Constructors"){

                }
                NavigationLink("2.3 Inheritance"){

                }
                NavigationLink("2.4 Pointers and Memory"){

                }
            }
        }.navigationTitle("C++ Programming")
    }

    // Right line: next level. Wrong line: show a hint and try again.
    private func check(_ line:Int) {
        if line == bugLines[level] {
            score += 1
            message = "Bug squashed! 🎉 \(hints[level])"

            if level == codes.count - 1 {
                level = 0
            }
            else{
                level += 1
            }
        }
        else{
            message = "Not that one. Hint: \(hints[level])"
        }
    }
}

#Preview {
    NavigationStack {
        CppPage()
    }
}
