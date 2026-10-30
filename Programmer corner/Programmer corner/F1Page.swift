//
//  F1Page.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import SwiftUI

struct F1Page: View {
    // 0 = no lights, 1 to 5 = red lights on, 6 = lights out (race started)
    @State private var lights:Int = 0

    var body: some View {
        List{
            // An F1 race start: tap to turn on the 5 red lights
            Section
            {
                VStack(spacing: 16){
                    Image(.F_1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

                    HStack{
                        ForEach(1...5, id: \.self) { number in
                            Circle()
                                .fill(number <= lights && lights < 6 ? Color.red : Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                        }
                    }

                    Text(lights == 6 ? "LIGHTS OUT AND AWAY WE GO! 🏁" : "Tap to turn on the lights")
                        .fontWeight(.bold)

                    Button(lights == 6 ? "Restart" : "Next Light") {
                        if lights == 6 {
                            lights = 0
                        }
                        else{
                            lights += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            Section("Unit-1 Race Weekend = Building an App")
            {
                NavigationLink("1.1 Practice = Trying Ideas"){
                    ScrollView{
                        VStack{
                            Text("How is building an app like an F1 race weekend?")
                        }
                    }
                }
                NavigationLink("1.2 Qualifying = Testing"){

                }
                NavigationLink("1.3 Race Day = Launching on the App Store"){

                }
                NavigationLink("1.4 Pit Stop = Fixing Bugs Fast"){

                }
            }
            Section("Unit-2 The Tech Behind F1")
            {
                NavigationLink("2.1 How Cars Send Live Data"){

                }
                NavigationLink("2.2 Simulators and Race Strategy"){

                }
                NavigationLink("2.3 Build a Lap Timer in Swift"){

                }
            }
        }.navigationTitle("F1")
    }
}

#Preview {
    NavigationStack {
        F1Page()
    }
}
