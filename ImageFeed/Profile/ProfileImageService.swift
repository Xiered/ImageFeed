import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let tokenStorage = OAuth2TokenStorage()
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else { return }
        
        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // dataTask
    }
    
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let small: String
    }
}

