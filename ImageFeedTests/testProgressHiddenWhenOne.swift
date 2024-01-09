//
//  testProgressHiddenWhenOne.swift
//  ImageFeedTests
//
//  Created by Дмитрий Герасимов on 27.12.2023.
//

@testable import ImageFeed
import XCTest

final class testProgressHiddenWhenOne: XCTestCase {
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
}
