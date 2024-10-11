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
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let error = signUpError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Button(action: signUp) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Sign Up")
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
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}
