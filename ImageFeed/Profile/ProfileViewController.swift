import UIKit
import Kingfisher
import WebKit
import ProgressHUD
import SwiftKeychainWrapper

public protocol ProfileViewControllerProtocol: AnyObject {
     var presenter: ProfileViewPresenterProtocol? { get }
     func updateAvatar()
     func updateProfileDetails(profile: Profile?)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Properties
      var presenter: ProfileViewPresenterProtocol?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    internal var nameLabel: UILabel!
    internal var loginLabel: UILabel!
    internal var avatarImage: UIImageView!
    internal var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        unionElementsForUI()
    }
    
    // MARK: - Methods
     // Subscription for avatar updating
     private func subscriptionForNotification() {
         profileImageServiceObserver = NotificationCenter.default
             .addObserver(forName: ProfileImageService.DidChangeNotification,
                          object: nil,
                          queue: .main)
         { [weak  self] _ in
             guard let self = self else { return }
             self.presenter?.updateAvatar()
         }
         presenter?.updateAvatar()
         updateProfileDetails(profile: profileService.profile)
     }
     
     func updateAvatar() {
         guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
         else { return }
         let placeholder = UIImage(systemName: "profile_view")
         avatarImage.kf.setImage(with: url, placeholder: placeholder)
     }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
     
     func updateProfileDetails(profile: Profile?) {
         if let profile = profile {
             nameLabel.text = profile.name
            loginLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        } else {
            nameLabel.text = "Errot with name"
            loginLabel.text = "Error with login"
            descriptionLabel.text = "Error with description"
        }
    } 
    // Options for Profile avatar
    private func makingAvatarImage(safeArea: UILayoutGuide) {
        avatarImage = UIImageView()
        avatarImage.image = UIImage(named: "profile_view")
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = 35
        view.addSubview(avatarImage)
    }
    // Options for Profile name
    private func makingNameLabel(safeArea: UILayoutGuide) {
        nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        view.addSubview(nameLabel)
    }
    // Options for Profile login
    private func makingLoginLabel(safeArea: UILayoutGuide) {
        loginLabel = UILabel()
        loginLabel.text = "@nov_ekaterina"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(loginLabel)
    }
    // Options for Profile description
    private func makingDescriptionLabel(safeArea: UILayoutGuide) {
        descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(descriptionLabel)
    }
    // Options for Profile back button
    private func makingLogoutButton(safeArea: UILayoutGuide) {
        logoutButton = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage(),
                                             target: self,
                                             action: nil)
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.accessibilityIdentifier = "logout button"
    }
    
    // Merging methods for UI (View-elements, constraints, update-functions)
    private func unionElementsForUI() {
        makingNameLabel(safeArea: view.safeAreaLayoutGuide)
        makingLoginLabel(safeArea: view.safeAreaLayoutGuide)
        makingAvatarImage(safeArea: view.safeAreaLayoutGuide)
        makingDescriptionLabel(safeArea: view.safeAreaLayoutGuide)
        makingLogoutButton(safeArea: view.safeAreaLayoutGuide)
        constraintsLayout()
        updateAvatar()
        updateProfileDetails(profile: profileService.profile)
        subscriptionForNotification()
        
        view.backgroundColor = UIColor(named: "YP Black")
    }
    // Constraints for View elements
    private func constraintsLayout() {
        NSLayoutConstraint.activate([
            // Avatar constraints settings
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            // Name constraints settings
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            // Login constraints settings
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            // Description constraints settings
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            // Back button constraints settings
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor)
            ])
    }
    
    @objc private func logoutButtonTapped() { // Alert for logout button action
        let alert = UIAlertController(title: "Пока, Пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Пока_пока"
        let doingAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.accountLogout()
        }
        doingAction.accessibilityIdentifier = "doing_action"
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alert.addAction(doingAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func accountLogout() {
        tokenStorage.cleanToken()
        UIBlockingProgressHUD.show()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast) // Clearing Coockies
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        let window = UIApplication.shared.windows.first
        let splashVC = SplashViewController()
        window?.rootViewController = splashVC
        UIBlockingProgressHUD.dismiss()
    }
}






