//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Герасимов on 19.11.2023.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController{
    
    private let ShowAuthenticationScreenSegueIdentifier = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let token = OAuth2TokenStorage().token {
            // TODO - auth check
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
