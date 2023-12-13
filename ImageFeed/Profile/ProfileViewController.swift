import UIKit

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarView = UIImageView()
        let avatarImage = UIImage(named: "profile_view")
        avatarView.image = avatarImage
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarView)
        
        let logoutButtonImage = UIImage(systemName: "ipad.and.arrow.forward")
        let logoutButton = UIButton.systemButton(
            with: logoutButtonImage!,
            target: self,
            action: #selector(logout))
        
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 16),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 40),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor,
                                           constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                            constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor,
                                                  constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            
        ])
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: nil,
                         queue: .main)
        { [weak  self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO update avatar via Kingfisher
    }
    
    @objc
    private func logout() {
        
    }
}


