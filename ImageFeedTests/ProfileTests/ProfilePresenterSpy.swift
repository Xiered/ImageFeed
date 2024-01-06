import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true 
    }
    func updateAvatar() {
         
    }
}
