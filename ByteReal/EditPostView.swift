//
//  EditPostView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/11/24.
//

import SwiftUI

struct EditPostView: View {
    var post: Post
    @Binding var isPresented: Bool
    var onSave: (Post) -> Void
    var onDelete: (Post) -> Void

    @State private var editedText: String
    @State private var editedCodeSnippet: String

    init(post: Post, isPresented: Binding<Bool>, onSave: @escaping (Post) -> Void, onDelete: @escaping (Post) -> Void) {
        self.post = post
        self._isPresented = isPresented
        self.onSave = onSave
        self.onDelete = onDelete
        self._editedText = State(initialValue: post.text)
        self._editedCodeSnippet = State(initialValue: post.codeSnippet ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Post")) {
                    TextField("Post Text", text: $editedText)
                    TextField("Code Snippet (optional)", text: $editedCodeSnippet)
                }
            }
            .navigationTitle("Edit Post")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: HStack {
                    Button("Delete") {
                        onDelete(post)
                        isPresented = false
                    }
                    .foregroundColor(.red)

                    Button("Save") {
                        var updatedPost = post
                        updatedPost.text = editedText
                        updatedPost.codeSnippet = editedCodeSnippet
                        onSave(updatedPost)
                        isPresented = false
                    }
                    .disabled(editedText.isEmpty) 
                }
            )
        }
    }
}
