//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Герасимов on 26.12.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
}
