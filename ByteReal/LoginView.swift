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
            Color.black // Black background
                .edgesIgnoringSafeArea(.all)
            
            // Add logo image
            Image("ByteReal") // Use the name of your PNG file (without the extension)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150) // Set your desired width and height
        }
    }
}

struct LoginView: View {
    @Binding var isLoggedIn: Bool  // Accept binding
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingSignUp = false
    @State private var loginError: String?
    
    @State private var showSplash = true // Control splash screen display

    var body: some View {
        ZStack {
            // Show the splash screen
            if showSplash {
                SplashScreen()
                    .onAppear {
                        // Delay before showing the login screen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Adjust the duration as needed
                            withAnimation {
                                showSplash = false // Hide splash screen
                            }
                        }
                    }
            } else {
                // Set the background color to black
                Color.black
                    .edgesIgnoringSafeArea(.all) // Extend color to the edges
                
                VStack {
                    Spacer().frame(height: 30) // Reduce space above the logo to move it up more
                    
                    // Add logo image
                    Image("ByteReal") // Use the name of your PNG file (without the extension)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150) // Set your desired width and height
                    
                    // Custom Text Field for Username
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.clear) // Transparent background
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1) // Border around the text field
                        )
                        .autocapitalization(.none)
                        .foregroundColor(.white) // Text color for input
                        .font(.system(size: 18, weight: .medium)) // Set custom font size and weight
                        .placeholder(when: username.isEmpty) { // Placeholder modifier
                            Text("Username").foregroundColor(.white.opacity(0.5)) // Placeholder color
                                .font(.system(size: 18, weight: .medium)) // Set placeholder font size and weight
                        }
                        .frame(width: 300) // Set a fixed width for the username field
                    
                    // Custom Secure Field for Password
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.clear) // Transparent background
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1) // Border around the secure field
                        )
                        .foregroundColor(.white) // Text color for input
                        .font(.system(size: 18, weight: .medium)) // Set custom font size and weight
                        .placeholder(when: password.isEmpty) { // Placeholder modifier
                            Text("Password").foregroundColor(.white.opacity(0.5)) // Placeholder color
                                .font(.system(size: 18, weight: .medium)) // Set placeholder font size and weight
                        }
                        .frame(width: 300) // Set a fixed width for the password field
                    
                    if let error = loginError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                            .font(.system(size: 14, weight: .regular)) // Set error text style
                    }

                    // Create a horizontal stack for the buttons
                    HStack(spacing: 20) { // Add spacing between buttons
                        Button(action: login) {
                            Text("Log In")
                                .padding()
                                .frame(width: 120) // Set a fixed width for the button
                                .background(Color.purple) // Change to purple
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.system(size: 18, weight: .bold)) // Set custom button font
                        }
                        
                        Button(action: {
                            showingSignUp.toggle()
                        }) {
                            Text("Sign Up")
                                .padding()
                                .frame(width: 120) // Set a fixed width for the button
                                .background(Color.purple) // Change to purple
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.system(size: 18, weight: .bold)) // Set custom button font
                        }
                    }
                    .padding(.top) // Optional padding to separate from text fields
                    .padding(.horizontal) // Padding for the HStack
                    
                }
                .padding() // Optional: Add some padding to the VStack
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
                    .padding(.leading, 5) // Adjust padding if necessary
            }
        }
    }
}
