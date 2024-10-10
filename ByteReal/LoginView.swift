//
//  LoginView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import SwiftUI
import ParseSwift

struct LoginView: View {
    @Binding var isLoggedIn: Bool  // Accept binding
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingSignUp = false
    @State private var loginError: String?
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let error = loginError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: login) {
                Text("Log In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                showingSignUp.toggle()
            }) {
                Text("Sign Up")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Login")
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
    
    private func login() {
        // Handle login with Parse
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
            }
        }
    }
}
