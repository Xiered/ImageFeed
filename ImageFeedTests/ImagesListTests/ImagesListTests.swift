import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testImagesListViewControllerCallsViewDidLoad() {
        let imagesListVC = ImagesListViewController()
        let imagesListVP = ImageListViewPresenterSpy()
        imagesListVC.configure(imagesListVP)
        
        XCTAssertTrue(imagesListVP.updateIsCalled)
    }
}
