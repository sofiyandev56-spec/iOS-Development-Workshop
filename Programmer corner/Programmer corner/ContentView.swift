//
//  ContentView.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 29/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var email:String = ""
    @State private var password:String = ""
    // Sample login for the demo (not a real account)
    @State private var testEmail:String = "test@example.com"
    @State private var testPassword:String = "password123"
    @State private var goToHome: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("KING SHAIKH")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                
                Text("PRECISION. PRESTIGE. POWER")
                
                HStack{
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(.gray)
                    TextField("example@example.com", text: $email)
                }
                .padding(.horizontal)
                .frame(width:360, height: 60)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .opacity(0.6)
                
                HStack{
                    Image(systemName: "key.fill")
                        .foregroundStyle(.gray)
                    SecureField("Password", text: $password)
                }
                .padding(.horizontal)
                .frame(width:360, height: 60)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .opacity(0.6)
                
                Button {
                    print("Login tapped")
                    
                    //logic
                    if email == testEmail && password == testPassword {
                        goToHome = true
                    }
                    else{
                        print("Either Username or password is wrong")
                        showAlert = true
                    }
                    
                } label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 360, height: 60)
                        .background(.black)
                        .cornerRadius(16)
                        .opacity(0.6)
                }
            }
            // Fill the screen so the wallpaper covers all of it
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image(.background)
                    .resizable()
                    .scaledToFill()
                    //.blur(radius: 6, opaque: true)   // light blur, no faded edges
                    //.opacity(0.6)                    // softer wallpaper
                    .ignoresSafeArea()
            }.ignoresSafeArea()
            .navigationDestination(isPresented: $goToHome)
            {
                homePage()
            }
            .alert("Login Failed", isPresented: $showAlert)
            {
                Button("Ok", role: .cancel) {}
            }message: {
                Text("Username or Password is incorrect")
            }
        }
    }
}

#Preview {
    ContentView()
}
