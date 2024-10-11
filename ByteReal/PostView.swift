//
//  PostView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/11/24.
//
import SwiftUI
import ParseSwift
import UIKit

struct PostView: View {
    var post: Post
    var onDelete: (Post) -> Void
    var onEdit: (Post) -> Void

    // Assuming you have a way to access the current user
    var currentUser: User? {
        return User.current // Adjust this according to your user management
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Display the author's name
            if let author = post.user?.username {
                Text(author)  // Show the username of the author
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Display the post creation time
            if let createdAt = post.createdAt {
                Text("Posted on \(formattedDate(createdAt))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text(post.text)
                .font(.system(size: 16)) // Use the default system font for text
                .padding(10)
                .background(Color(.systemGray6)) // Light gray background for the post
                .cornerRadius(8)

            if let codeSnippet = post.codeSnippet {
                Text(codeSnippet)
                    .font(.custom("Menlo", size: 14)) // Menlo font for code
                    .padding(10)
                    .background(Color(.systemGray5)) // Slightly darker gray for code snippet
                    .cornerRadius(8)
                    .padding(.top, 5)
            }

            // Only show Edit and Delete buttons if the post belongs to the current user
            if let currentUserId = currentUser?.objectId, let postUserId = post.user?.objectId, postUserId == currentUserId {
                HStack {
                    Button("Edit") {
                        onEdit(post)
                    }
                    .foregroundColor(.blue)

                    Spacer()

                    Button(action: {
                        onDelete(post)
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding(.vertical, 5)
    }

    // Helper function to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
