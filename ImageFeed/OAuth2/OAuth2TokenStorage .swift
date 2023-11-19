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
            guard let userDefaultsData = UserDefaults.standard.data(forKey: "token"),
                    let decodeToken = try? JSONDecoder().decode(String.self, from: userDefaultsData)
            else { return nil }
            return self.token
        }
        set {
            guard let userDefaultsData = try? JSONEncoder().encode(newValue) 
            else {
                print("Ошибка сохранения токена")
                return
            }
            UserDefaults.standard.set(userDefaultsData, forKey: "token")
        }
    }
}
