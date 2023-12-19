import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let tokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var splashScreenLogo: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoSplashScreen(safeArea: view.safeAreaLayoutGuide)
        
        if let token = tokenStorage.token {
           fetchProfile(token: token)
        } else {
            delegateAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
            showSplashViewAlert()
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
        UIBlockingProgressHUD.show()
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let token):
                self.fetchProfile(token: token)
            case .failure:
               showSplashViewAlert()
               break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async{
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.profileImageService.fetchProfileImageURL(username: result.userName) { _ in }
                    self.switchToTabBarController()
                case .failure:
                    self.showSplashViewAlert()
                    break
                }
            }
        }
    }
    
    private func showSplashViewAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        
        let actionWithAlert = UIAlertAction(title: "Ок",
                                            style: .default)
        
        alert.addAction(actionWithAlert)
    }
    
    private func logoSplashScreen(safeArea: UILayoutGuide) {
        view.backgroundColor = UIColor(named: "YP Black")
        splashScreenLogo = UIImageView()
        splashScreenLogo.image = UIImage(named: "splash_screen_logo")
        splashScreenLogo.contentMode = .scaleToFill
        splashScreenLogo.clipsToBounds = true
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashScreenLogo)
        NSLayoutConstraint.activate([
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func delegateAuthViewController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
         else { fatalError("Invalid action") }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
}
