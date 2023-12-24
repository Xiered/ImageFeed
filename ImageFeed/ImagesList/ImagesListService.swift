import UIKit

final class ImagesListService {
    private var lastLoadedPage: Int? = nil
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var currentPage = 1
    private let tokenStorage = OAuth2TokenStorage()
    private let pagesCount = 10
    private var isFetching = false
    static let shared = ImagesListService()
    
    private init() { }
    
    // MARK: - Methods
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return }
        isFetching = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            guard let url = URL(string: "https://api.unsplash.com/photos?page=\(self.currentPage)&per_page=\(self.pagesCount)"),
                  let token = tokenStorage.token else {
                self.isFetching = false
                return
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self, let data = data else {
                    self?.isFetching = false
                    return
                }
                do {
                    let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                    let newPhotos = photoResults.map { photoResult in
                        return Photo(
                            id: photoResult.id,
                            size: CGSize(width: photoResult.width, height: photoResult.height),
                            createdAt: self.dateFromString(photoResult.createdAt),
                            welcomeDescription: photoResult.description,
                            thumbImageURL: photoResult.urls.thumb,
                            largeImageURL: photoResult.urls.regular,
                            fullImageURL: photoResult.urls.full,
                            isLiked: photoResult.likedByUser
                        )}
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.photos.append(contentsOf: newPhotos)
                        NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                        self.isFetching = false
                        self.currentPage += 1
                        self.lastLoadedPage = self.currentPage - 1
                        UIBlockingProgressHUD.dismiss()
                    }
                } catch {
                    print("Error JSON decoding \(error)")
                    self.isFetching = false
                }
            }
            task.resume()
        }
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: dateString)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) { // Avoidance circuit
        guard let token = tokenStorage.token else { return }
        
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            }
            if let responseCode = { response as? HTTPURLResponse}()?.statusCode {
                if 200..<300 ~= responseCode {
                } else {
                    completion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            }
            completion(.success(()))
        }
        task.resume()
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
    let fullImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let description: String?
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
