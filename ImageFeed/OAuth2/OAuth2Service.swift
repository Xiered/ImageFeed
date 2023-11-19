//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Дмитрий Герасимов on 16.11.2023.
//

import Foundation

final class OAuth2Service {
    
    private enum NetworkError: Error {
        case urlSessionError
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        //      completion(.success(""))
        // Обращение к URL
        var components = URLComponents(string: "https://unsplash.com/oauth/token")
        components?.queryItems = [URLQueryItem(name: "client_id", value: AccessKey),
                                  URLQueryItem(name: "client_secret", value: SecretKey),
                                  URLQueryItem(name: "redirect_uri", value: RedirectURI),
                                  URLQueryItem(name: "code", value: "code"),
                                  URLQueryItem(name: "grant_type", value: "authorization_code ")]
        
        if let url = components?.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            // "Задание" для URL
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                guard let data = data else { return }
               guard let sessionResponse = try? JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                else {
                   DispatchQueue.main.async {
                       completion(.failure(NetworkError.urlSessionError))
                   }
                   return
               }
                DispatchQueue.main.async {
                    completion(.success(""))
                }
                
            })
            task.resume()
        }
    }
}


