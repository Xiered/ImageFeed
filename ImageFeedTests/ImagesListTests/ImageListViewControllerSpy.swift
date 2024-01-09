import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {}
}
