import Foundation

enum OAuthStorageKeys: String {
    case OAuthStorageKey
}

protocol OAuthStorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: OAuthStorageProtocol {
    
    private let userDefaults = UserDefaults.standard
    init() {}
    
    var token: String? {
        
        get {
            userDefaults.string(forKey: OAuthStorageKeys.OAuthStorageKey.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: OAuthStorageKeys.OAuthStorageKey.rawValue)
        }
    }
}
