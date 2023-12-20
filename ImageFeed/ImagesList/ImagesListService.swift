import UIKit

final class ImagesListService {
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let currentPage = 1
    private let tokenStorage = OAuth2TokenStorage()
    private let pagesCount = 10
    private var isFetching = false
    
    private init() { }
    
    // MARK: - Methods
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return }
        isFetching = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            guard let url = URL(string: "https://api.unsplash.com/photos?page=\(self.currentPage)&per_page=\(self.pagesCount)"),
                  let token = tokenStorage.token else {
                self.isFetching = false
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            // let task TODO 
        }
    }
}
// MARK: - Model

// Structures for JSON-fields
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: Int
    let updatedAt: Int
    let width: Int
    let height: Int
    let description: String
    let urls: UrlsResult
    let likes: Int
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
        case width
        case height
        case description
        case urls
        case likes
        case likedByUser = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
