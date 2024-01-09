import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateAvatar()
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
   weak var view: ProfileViewControllerProtocol?
     private let profileService: ProfileServiceProtocol
     private let profileImageService: ProfileImageServiceProtocol
     
     init(
     profileService: ProfileServiceProtocol = ProfileService.shared,
     profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
     ) {
     self.profileService = profileService
     self.profileImageService = profileImageService
     } 
    
    func viewDidLoad() {
        view?.updateProfileDetails(profile: profileService.profile)
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar()
    }
    
}
