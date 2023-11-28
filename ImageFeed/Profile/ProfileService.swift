import UIKit

final class ProfileService {
    struct ProfileResult: Codable { // Structure for Unsplash answer decoding
        
    }
    
    struct Profile {
        var username: String
        var name: String
        var loginName: String
        var bio: String
    }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
    }
}
