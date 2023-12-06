import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    
    func fetchProfileImage(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
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

