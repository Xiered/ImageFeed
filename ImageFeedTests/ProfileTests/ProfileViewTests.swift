import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() throws {
        
        // Given
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfilePresenterSpy()
        profileViewController.configure(profileViewPresenter)
        
        // When
        _ = profileViewController.view
        
        // Then
        XCTAssertTrue(profileViewPresenter.viewDidLoadCalled)
    }
}
