//
//  HomeView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import SwiftUI
import ParseSwift

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    @State private var posts: [Post] = []
    @State private var newPostText = ""
    @State private var newPostImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            VStack {
                List(posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.text)
                            .font(.headline)
                        if let imageData = post.image {
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                        }
                        Text("Posted on: \(post.createdAt?.description ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    TextField("What's on your mind?", text: $newPostText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add Image") {
                        showImagePicker = true
                    }
                }.padding()
                
                Button("Post") {
                    createPost()
                }
                .padding()
                
                Button("Logout") {
                    logoutUser()
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarItems(trailing: NavigationLink("Profile", destination: ProfileView()))
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $newPostImage) // Assuming you have an ImagePicker implementation
            }
        }
        .onAppear {
            fetchPosts()
        }
    }

    private func fetchPosts() {
        // Fetch posts from Back4App
        Post.query().find { result in
            switch result {
            case .success(let fetchedPosts):
                self.posts = fetchedPosts
            case .failure(let error):
                print("Error fetching posts: \(error.localizedDescription)")
            }
        }
    }

    private func createPost() {
        var post = Post()
        post.text = newPostText
        post.image = newPostImage?.jpegData(compressionQuality: 0.8) // Convert UIImage to Data
        post.isPrivate = false // Set to true if you want a private post
        post.user = User.current // Set the current user as the post's author

        // Save the post
        post.save { result in
            switch result {
            case .success:
                fetchPosts() // Refresh the list of posts
                newPostText = "" // Clear the text field
                newPostImage = nil // Reset the image
            case .failure(let error):
                print("Failed to create post: \(error.localizedDescription)")
            }
        }
    }

    private func logoutUser() {
        User.logout { result in
            switch result {
            case .success:
                isLoggedIn = false // Update the state to show the LoginView
            case .failure(let error):
                print("Logout failed: \(error.localizedDescription)")
            }
        }
    }
}
