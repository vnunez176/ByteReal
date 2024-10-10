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

    var body: some View {
        List(userPosts) { post in
            VStack(alignment: .leading) {
                Text(post.text)
                Text("Posted on: \(post.createdAt?.description ?? "Unknown date")")
            }
        }
        .navigationTitle("My Posts")
        .onAppear {
            fetchUserPosts()
        }
    }

    private func fetchUserPosts() {
        // Check if the user is logged in
        //            guard let currentUser = User.current else {
        //                print("No current user.")
        //                return
        //            }
        //
        //            // Create a query for Post
        //            let query = Post.query()
        //
        //            // Fetch user's posts from Back4App
        //            query.whereKey("user", equalTo: currentUser) // Use whereKey to filter by the current user
        //
        //            // Execute the query
        //            query.find { result in
        //                switch result {
        //                case .success(let fetchedPosts):
        //                    self.userPosts = fetchedPosts // Update the userPosts array with fetched posts
        //                case .failure(let error):
        //                    print("Error fetching user posts: \(error.localizedDescription)")
        //                }
        //            }
        //        }
    }
}

