import SwiftUI
import Combine


// MARK: - Model (matches JSON structure)
struct Post: Identifiable, Codable {
    let id: Int        
    let title: String  
    let body: String   
}


// MARK: - ViewModel (Networking)
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
            errorMessage = "JSON decoding failed"
        }

        isLoading = false
    }
}


// MARK: - UI
struct ContentView: View {
    @StateObject private var vm = PostsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading JSON...")
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(vm.posts) { post in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("JSON Analysis")
            .task {
                await vm.fetchPosts()
            }
        }
    }
}

