import ImageFeed

final class ImageListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var updateIsCalled: Bool = false
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func updateTableViewAnimated() {
        updateIsCalled = true
    }
}
