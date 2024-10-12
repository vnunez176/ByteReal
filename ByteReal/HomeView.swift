import SwiftUI
import ParseSwift

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    @State private var posts: [Post] = []
    @State private var newPostText = ""
    @State private var newPostCode = ""
    @State private var isPublic = true
    @State private var hasPostedToday = false
    @State private var showAlert = false
    @State private var errorMessage: String?
    
    @State private var isEditing = false
    @State private var editingPost: Post?
    @State private var showDeleteConfirmation = false
    @State private var postToDelete: Post?

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Background color
                
                VStack {
                    if hasPostedToday {
                        List(posts) { post in
                            PostView(post: post, onDelete: { post in
                                self.postToDelete = post
                                self.showDeleteConfirmation = true
                            }, onEdit: editPost)
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
                                    self.postToDelete = nil
                                }
                            )
                        }
                        .refreshable {
                            fetchPosts()
                        }
                    } else {
                        VStack {
                            Image(systemName: "lock.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray) // Change icon color
                                .blur(radius: 10)
                            
                            Text("You must post today to view posts.")
                                .font(.headline)
                                .foregroundColor(.purple) // Change text color
                                .padding(.bottom)

                            postInputSection
                        }
                    }
                    
                    logoutButton
                }
                .padding()
                .navigationTitle("Home").accentColor(.purple)
                .navigationBarTitleDisplayMode(.inline) // Display title inline
                .navigationBarItems(trailing: NavigationLink("Profile", destination: ProfileView()))
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
                }
            }
        }
        .accentColor(.purple) // Change the navigation title color to purple
        .onAppear {
            fetchPosts()
            checkPostReset()
        }
        .sheet(isPresented: $isEditing) {
            if let editingPost = editingPost {
                EditPostView(post: editingPost, isPresented: $isEditing, onSave: { updatedPost in
                    updatePost(post: updatedPost)
                    fetchPosts()
                }, onDelete: { postToDelete in
                    deletePost(post: postToDelete)
                    fetchPosts()
                })
            }
        }
    }
    
    private var postInputSection: some View {
        VStack(spacing: 15) {
            TextField("What's on your mind?", text: $newPostText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)

            CodeTextView(codeSnippet: $newPostCode, lineNumbers: true)
                .frame(height: 200) // Set height for the code input
                .background(Color.white)
                .cornerRadius(10)

            Toggle("Make Post Public", isOn: $isPublic)
                .padding()
                .foregroundColor(.purple)

            Button(action: {
                if isEditing, let editingPost = editingPost {
                    updatePost(post: editingPost)
                } else {
                    createPost()
                }
            }) {
                Text(isEditing ? "Update" : "Post")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(newPostText.isEmpty ? Color.gray : Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(newPostText.isEmpty)
        }
        .padding()
    }

    private var logoutButton: some View {
        Button(action: logoutUser) {
            Text("Logout")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.top)
    }

    private func fetchPosts() {
        do {
            let query = try Post.query("isPrivate" == false)
                .include("user")
                .order([.descending("createdAt")])

            query.find { result in
                switch result {
                case .success(let fetchedPosts):
                    self.posts = fetchedPosts
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

    private func createPost() {
        guard !newPostText.isEmpty else { return }
        
        var post = Post()
        post.text = newPostText
        post.codeSnippet = newPostCode
        post.isPrivate = !isPublic
        post.user = User.current

        post.save { result in
            switch result {
            case .success:
                hasPostedToday = true
                fetchPosts()
                newPostText = ""
                newPostCode = ""
                updateLastPostDate()
            case .failure(let error):
                errorMessage = "Failed to create post: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func deletePost(post: Post) {
        post.delete { result in
            switch result {
            case .success:
                hasPostedToday = false
                fetchPosts()
            case .failure(let error):
                errorMessage = "Failed to delete post: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func editPost(post: Post) {
        guard let currentUser = User.current, post.user?.objectId == currentUser.objectId else {
            errorMessage = "You can only edit your own posts."
            showAlert = true
            return
        }

        editingPost = post
        newPostText = post.text
        newPostCode = post.codeSnippet ?? ""
        isEditing = true
    }

    private func updatePost(post: Post) {
      
        post.save { result in
            switch result {
            case .success:
                fetchPosts() // Refresh posts after successful update
                newPostText = "" // Clear the text field
                newPostCode = "" // Clear the code snippet field
                isEditing = false // Close edit mode
                editingPost = nil // Reset editing post
            case .failure(let error):
                errorMessage = "Failed to update post: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func logoutUser() {
        User.logout { result in
            switch result {
            case .success:
                isLoggedIn = false
            case .failure(let error):
                errorMessage = "Logout failed: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func checkPostReset() {
        guard let currentUser = User.current else {
            errorMessage = "Current user is not available."
            showAlert = true
            return
        }

        do {
            let today = Calendar.current.startOfDay(for: Date())
            let query = try Post.query("user" == currentUser)
                .where("createdAt" >= today)

            query.find { result in
                switch result {
                case .success(let userPosts):
                    hasPostedToday = !userPosts.isEmpty
                case .failure(let error):
                    errorMessage = "Failed to check today's posts: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        } catch {
            errorMessage = "Error creating query: \(error.localizedDescription)"
            showAlert = true
        }
    }

    private func updateLastPostDate() {
        if var currentUser = User.current {
            currentUser.lastPostDate = Date()
            currentUser.save { result in
                switch result {
                case .success:
                    print("Last post date updated successfully.")
                case .failure(let error):
                    errorMessage = "Failed to update last post date: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

