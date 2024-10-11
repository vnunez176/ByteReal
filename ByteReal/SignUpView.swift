//
//  Untitled.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//
import SwiftUI
import ParseSwift

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var email: String = ""
    @State private var signUpError: String?

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.black.edgesIgnoringSafeArea(.all) // Black background
                
                VStack(spacing: 20) {
                    // Logo or Title (Optional)
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple) // Purple text for title
                        .padding(.top, 40)

                    // Username Field
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.clear) // Transparent background
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple, lineWidth: 2) // Purple border
                        )
                        .autocapitalization(.none)
                        .foregroundColor(.white) // Text color for input
                        .placeholder(when: username.isEmpty) {
                            Text("Username").foregroundColor(.white.opacity(0.5))
                        }

                    // Email Field
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.clear) // Transparent background
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple, lineWidth: 2) // Purple border
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundColor(.white) // Text color for input
                        .placeholder(when: email.isEmpty) {
                            Text("Email").foregroundColor(.white.opacity(0.5))
                        }

                    // Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.clear) // Transparent background
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple, lineWidth: 2) // Purple border
                        )
                        .foregroundColor(.white) // Text color for input
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.white.opacity(0.5))
                        }

                    // Confirm Password Field
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.clear) // Transparent background
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple, lineWidth: 2) // Purple border
                        )
                        .foregroundColor(.white) // Text color for input
                        .placeholder(when: confirmPassword.isEmpty) {
                            Text("Confirm Password").foregroundColor(.white.opacity(0.5))
                        }

                    // Display error message
                    if let error = signUpError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // Sign Up Button
                    Button(action: signUp) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple) // Purple background
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline) // Font style for button
                    }
                    .padding(.horizontal)
                }
                .padding() // Optional: Add some padding to the VStack
            }
            .navigationTitle("") // Hide the title
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func signUp() {
        // Log out current user before signing up
        if let _ = User.current {
            User.logout { result in
                switch result {
                case .success:
                    performSignUp()  // After logging out, sign up the new user
                case .failure(let error):
                    signUpError = "Logout failed: \(error.localizedDescription)"
                }
            }
        } else {
            performSignUp()
        }
    }

    private func performSignUp() {
        // Basic validation
        guard !username.isEmpty, !password.isEmpty, !email.isEmpty else {
            signUpError = "All fields are required."
            return
        }

        guard password == confirmPassword else {
            signUpError = "Passwords do not match."
            return
        }

        guard isValidEmail(email) else {
            signUpError = "Please enter a valid email."
            return
        }

        // Create a new user with email, username, and password
        var newUser = User()
        newUser.username = username
        newUser.password = password
        newUser.email = email

        // Sign up the new user
        newUser.signup { result in
            switch result {
            case .success:
                // Handle successful sign-up, dismiss the sign-up view
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                // Handle sign-up error
                signUpError = error.localizedDescription
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}

