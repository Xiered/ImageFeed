//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Дмитрий Герасимов on 27.12.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase{
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}


