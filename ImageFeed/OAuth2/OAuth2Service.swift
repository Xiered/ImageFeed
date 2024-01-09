import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private var lastCode: String?
    
    // Property for saving Authentication token
    private (set) var authToken: String? {
        
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    // Method for executing a request to obtain a token
    func fetchOAuthToken(_ code: String, completion: @escaping(Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread) // Install in main thread
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeHTTPRequest(code: String) -> URLRequest {
        guard let url = URL(string: "defaultBaseUrl\(code)") else { fatalError("Failed to load URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
            
            let decoder = JSONDecoder()
            
            return urlSession.data(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                    Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
                }
                completion(response)
            }
        }
    
    // Passing path and method with base url to request token
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AuthConfiguration.standard.accessKey)"
            + "&&client_secret=\(AuthConfiguration.standard.secretKey)"
            + "&&redirect_uri=\(AuthConfiguration.standard.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
