import Foundation

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = defaultBaseUrl) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!) // Static for override
        request.httpMethod = httpMethod
        return request
    }
}
