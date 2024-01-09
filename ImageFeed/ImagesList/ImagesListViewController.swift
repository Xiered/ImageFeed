import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    internal var presenter: ImagesListViewPresenterProtocol?
    
    @IBOutlet private var tableView: UITableView!

    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: ImagesListService.DidChangeNotification, object: nil)
        imagesListService.fetchPhotosNextPage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.fullImageURL = photos[indexPath.row].fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configure(_ presenter: ImagesListViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    @objc func updateTableView() {
        let previousCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if previousCount != newCount {
            tableView.performBatchUpdates({
                let indexPaths = (previousCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    } 
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        } else {
            return
        }
    }
    
}
// MARK: - Extensions

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell", for: indexPath) as? ImagesListCell else { fatalError("Cannot extract cell") }
        cell.delegate = self
        let photo = photos[indexPath.row]
        if let url = URL(string: photo.thumbImageURL) { // Kingfisher for loading image via URL
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url,
                                       placeholder: UIImage(named: "placeholder_cell"),
                                       options: []) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    if let created = photo.createdAt {
                        cell.dateLabel.text = self.dateFormatter.string(from: created)
                    } else {
                        cell.dateLabel.text = ""
                    }
                    cell.setIsLiked(photo.isLiked)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print(error)
                }
            }
        }
        return cell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }

        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())

        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_active") : UIImage(named: "like_button_inactive")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: /*photosName[indexPath.row]*/ "\(indexPath.row)") else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) { // For like button
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        let isLiked = !photo.isLiked
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: isLiked) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    cell.setIsLiked(isLiked)
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        let currentPhoto = self.photos[index]
                        let updatedPhoto = Photo(
                            id: currentPhoto.id,
                            size: currentPhoto.size,
                            createdAt: currentPhoto.createdAt,
                            welcomeDescription: currentPhoto.welcomeDescription,
                            thumbImageURL: currentPhoto.thumbImageURL,
                            largeImageURL: currentPhoto.largeImageURL,
                            fullImageURL: currentPhoto.fullImageURL,
                            isLiked: !currentPhoto.isLiked
                        )
                        self.photos.remove(at: index)
                        self.photos.insert(updatedPhoto, at: index)
                    }
                case .failure(let error):
                    print("Error to changing like: \(error)")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {

    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
}
