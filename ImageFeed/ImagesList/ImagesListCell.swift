import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) { // Method for changing the like status picture
        if isLiked {
            self.likeButton.imageView?.image = UIImage(named: "like_button_active")
        } else {
            self.likeButton.imageView?.image = UIImage(named: "like_button_inactive")
        }
    }
    
    override func prepareForReuse() { // For avoid bugs
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask() // Сanceling cell loading to avoid bugs when reusing a cell
    }
}

protocol ImagesListCellDelegate: AnyObject { 
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
