import SwiftUI
import Combine

// MARK: - Model
struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
}

// MARK: - ViewModel
@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchPosts() async {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            posts = try JSONDecoder().decode([Post].self, from: data)
        } catch {
            errorMessage = "Failed to load posts"
        }

        isLoading = false
    }
}

// MARK: - Main UI
struct ContentView: View {

    // Reactive UI state
    @State private var showPosts = false
    @StateObject private var vm = PostsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // ✅ FORM
                Form {
                    Section(
                        header: Label("Actions", systemImage: "square.and.pencil")
                    ) {
                        Button {
                            showPosts.toggle()
                            if showPosts {
                                Task {
                                    await vm.fetchPosts()
                                }
                            }
                        } label: {
                            Label(
                                showPosts ? "Hide Posts" : "Load Posts",
                                systemImage: "arrow.down.circle"
                            )
                        }
                    }
                }
                .frame(height: 200)

                // ✅ LOADING
                if vm.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }

                // ✅ ERROR
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                // ✅ LIST
                if showPosts {
                    List(vm.posts) { post in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .navigationTitle("Design & UX")
        }
    }
}
