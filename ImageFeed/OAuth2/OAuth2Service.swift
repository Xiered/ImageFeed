//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Дмитрий Герасимов on 16.11.2023.
//

import Foundation

final class OAuth2Service {
    private enum NetworkError: Error {
        case codeError
    }
    
    
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
}
