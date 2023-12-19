import UIKit

final class ImagesListService {
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        
    }
    
}

extension ImagesListService { // Structure for JSON-fields
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
    }
}
