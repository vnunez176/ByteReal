//
//  LoginView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import SwiftUI
import ParseSwift

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // Add logo image
            Image("ByteReal")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
        }
    }
}

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingSignUp = false
    @State private var loginError: String?
    
    @State private var showSplash = true

    var body: some View {
        ZStack {
            // Show the splash screen
            if showSplash {
                SplashScreen()
                    .onAppear {
                        // Delay before showing the login screen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
              
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer().frame(height: 30)
                    
                    // Add logo image
                    Image("ByteReal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    // Custom Text Field for Username
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                        .placeholder(when: username.isEmpty) {
                            Text("Username").foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 18, weight: .medium))
                        }
                        .frame(width: 300)
                    
                    // Custom Secure Field for Password
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 18, weight: .medium))
                        }
                        .frame(width: 300)
                    
                    if let error = loginError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                            .font(.system(size: 14, weight: .regular))
                    }

      
                    HStack(spacing: 20) {
                        Button(action: login) {
                            Text("Log In")
                                .padding()
                                .frame(width: 120)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        Button(action: {
                            showingSignUp.toggle()
                        }) {
                            Text("Sign Up")
                                .padding()
                                .frame(width: 120)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                }
                .padding()
            }
        }
        .navigationTitle("Login")
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
    
    private func login() {
        User.login(username: username, password: password) { result in
            switch result {
            case .success:
                // Update login state on the main thread
                DispatchQueue.main.async {
                    isLoggedIn = true
                }
            case .failure(let error):
                // Handle login error
                loginError = error.localizedDescription
                print("Login failed with error: \(error.localizedDescription)")
                print("Error details: \(error)")
            }
        }
    }
}

// MARK: - Placeholder Modifier
extension View {
    func placeholder<Content: View>(when shouldShow: Bool, @ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            self
            if shouldShow {
                content()
                    .padding(.leading, 5) 
            }
        }
    }
}
