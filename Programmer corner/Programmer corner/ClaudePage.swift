//
//  ClaudePage.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct ClaudePage: View {
    @State private var tipNumber:Int = 0

    let tips:[String] = [
        "Paste your error message and ask: \"What does this mean?\"",
        "Ask Claude to explain your code line by line.",
        "Tell Claude what you want to build, then ask for the steps, not the full code.",
        "Ask: \"What would break if I change this line?\"",
        "Ask Claude to quiz you on what you learned today."
    ]

    var body: some View {
        List{
            // A new prompt idea every time you tap the button
            Section("Prompt of the Day")
            {
                VStack(alignment: .leading, spacing: 12){
                    HStack{
                        Image(.claude)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text("Try asking Claude:")
                            .font(.headline)
                    }

                    Text(tips[tipNumber])

                    Button("Next Tip") {
                        if tipNumber == tips.count - 1 {
                            tipNumber = 0
                        }
                        else{
                            tipNumber += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .padding(.vertical)
            }

            Section("Unit-1 Learning with Claude")
            {
                NavigationLink("1.1 What is Claude?"){
                    ScrollView{
                        VStack{
                            Text("What is Claude?")
                        }
                    }
                }
                NavigationLink("1.2 Writing a Good Prompt"){

                }
                NavigationLink("1.3 Ask for Explanations, Not Just Answers"){

                }
                NavigationLink("1.4 Fixing Errors Together"){

                }
            }
            Section("Unit-2 Building with Claude")
            {
                NavigationLink("2.1 Planning an App"){

                }
                NavigationLink("2.2 Claude Code in the Terminal"){

                }
                NavigationLink("2.3 Checking AI Code Before Using It"){

                }
            }
        }.navigationTitle("Claude")
    }
}

#Preview {
    NavigationStack {
        ClaudePage()
    }
}
