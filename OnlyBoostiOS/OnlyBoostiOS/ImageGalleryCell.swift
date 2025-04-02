import UIKit

class ImageGalleryCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageGalleryCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private var imageLoadTask: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }

    func configure(with identifier: String) {
        guard let url = URL(string: identifier) else {
            imageView.image = UIImage(systemName: "photo")
            return
        }

        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, self.identifierMatches(url.absoluteString) else { return }

            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "exclamationmark.triangle")
                }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "questionmark.diamond")
                }
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        imageLoadTask?.resume()
    }

    private func identifierMatches(_ urlString: String) -> Bool {
        return true
    }
}
