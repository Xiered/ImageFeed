import UIKit

final class ImagesListService {
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        
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
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
