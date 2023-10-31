//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Герасимов on 30.10.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
