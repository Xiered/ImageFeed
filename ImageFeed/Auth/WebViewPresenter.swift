//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Герасимов on 26.12.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    func viewDidLoad() {
        
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
}
