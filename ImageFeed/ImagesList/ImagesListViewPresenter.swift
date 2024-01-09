import UIKit

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func getPhotosCount() -> Int
    func updateTableViewAnimated()
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
   weak var view: ImagesListViewControllerProtocol?
    private var imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}
