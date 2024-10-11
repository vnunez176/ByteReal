//
//  ProfileView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import SwiftUI
import ParseSwift

struct ProfileView: View {
    @State private var userPosts: [Post] = []
    @State private var showDeleteConfirmation = false // Trigger delete confirmation
    @State private var postToDelete: Post? // Store post to delete
    @State private var errorMessage: String?
    @State private var showAlert = false

    var body: some View {
        List {
            ForEach(userPosts) { post in
                VStack(alignment: .leading) {
                    Text(post.text)
                    Text("Posted on: \(post.createdAt?.formatted() ?? "Unknown date")")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(post.isPrivate ? "Private" : "Public")
                        .font(.caption)
                        .foregroundColor(post.isPrivate ? .red : .green)

                    Button("Delete") {
                        // Show delete confirmation alert
                        self.postToDelete = post
                        self.showDeleteConfirmation = true
                    }
                    .foregroundColor(.red)
                }
                .padding()
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Post"),
                    message: Text("Are you sure you want to delete this post?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let postToDelete = self.postToDelete {
                            deletePost(post: postToDelete)
                        }
                    },
                    secondaryButton: .cancel {
                        self.postToDelete = nil // Reset postToDelete if canceled
                    }
                )
            }
        }
        .navigationTitle("My Posts")
        .onAppear {
            fetchUserPosts()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func fetchUserPosts() {
        guard let currentUser = User.current else {
            errorMessage = "Current user is not available."
            showAlert = true
            return
        }

        do {
            // Use currentUser as a reference for the query
            let query = try Post.query("user" == currentUser)
                .order([.descending("createdAt")])

            query.find { result in
                switch result {
                case .success(let fetchedPosts):
                    self.userPosts = fetchedPosts
                case .failure(let error):
                    self.errorMessage = "Error fetching posts: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        } catch {
            self.errorMessage = "Error creating query: \(error.localizedDescription)"
            self.showAlert = true
        }
    }

    private func deletePost(post: Post) {
        // Delete the post from Parse
        post.delete { result in
            switch result {
            case .success:
                // Refresh the user posts after deletion
                self.fetchUserPosts()
            case .failure(let error):
                self.errorMessage = "Failed to delete post: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
}
