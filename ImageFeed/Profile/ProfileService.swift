import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var fetchTask: URLSessionTask?
    private let urlSession = URLSession.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        fetchTask?.cancel()
        
        let url = URL(string: "https://api.unsplash.com/me")! 
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchTask = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(userName: profileResult.userName,
                                      name: "\(profileResult.firstName) \(profileResult.lastName)",
                                      loginName: "@\(profileResult.userName)",
                                      bio: profileResult.bio)
                self?.profile = profile
                completion(.success(profile))
            case .failure(_):
                completion(.failure(ProfileServiceError.invalidRequest))
            }
        }
        fetchTask?.resume()
    }
}

struct ProfileResult: Codable { // Structure for Unsplash answer decoding
    var userName: String
    var firstName: String
    var lastName: String
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile: Codable {
    var userName: String
    var name: String
    var loginName: String
    var bio: String?
}

enum ProfileServiceError: Error {
    case invalidRequest
    case invalidData
    case invalidDecoding
}


