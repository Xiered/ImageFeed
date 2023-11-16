//
//  OAuth2TokenStorage .swift
//  ImageFeed
//
//  Created by Дмитрий Герасимов on 16.11.2023.
//

import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        
        get {
            UserDefaults.standard.string(forKey: "token")
        }
            
        set {
            UserDefaults.standard.removeObject(forKey: "token")
        }
    }
}
