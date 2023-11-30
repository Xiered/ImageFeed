import UIKit

final class ProfileService {
    struct ProfileResult: Codable { // Structure for Unsplash answer decoding
        var userName: String
        var firstName: String
        var lastName: String
        var bio: String
    }
    
    struct Profile: Codable {
        var username: String
        var name: String
        var loginName: String
        var bio: String
    }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let url = URL(string: "https://api.unsplash.com/me") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
