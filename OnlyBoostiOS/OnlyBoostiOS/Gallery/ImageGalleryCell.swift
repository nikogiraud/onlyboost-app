import UIKit

class ImageGalleryCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageGalleryCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let shimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()

    private let shimmerGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray6.cgColor,
            UIColor.systemGray5.cgColor
        ]
        layer.locations = [0, 0.5, 1]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()

    private var imageLoadTask: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(shimmerView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        shimmerView.layer.addSublayer(shimmerGradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shimmerGradientLayer.frame = CGRect(
            x: -bounds.width,
            y: 0,
            width: bounds.width * 3,
            height: bounds.height
        )
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
        startShimmerAnimation()
        imageView.image = nil

        guard let url = URL(string: identifier) else {
            stopShimmerAnimation()
            imageView.image = UIImage(systemName: "photo")
            return
        }

        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, self.identifierMatches(url.absoluteString) else { return }

            DispatchQueue.main.async {
                self.stopShimmerAnimation()
                
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    self.imageView.image = UIImage(systemName: "exclamationmark.triangle")
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    self.imageView.image = UIImage(systemName: "questionmark.diamond")
                    return
                }

                self.imageView.image = image
            }
        }
        imageLoadTask?.resume()
    }

    private func startShimmerAnimation() {
        shimmerView.isHidden = false
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.5
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.repeatCount = .infinity
        shimmerGradientLayer.add(animation, forKey: "shimmer")
    }

    private func stopShimmerAnimation() {
        shimmerView.isHidden = true
        shimmerGradientLayer.removeAnimation(forKey: "shimmer")
    }

    private func identifierMatches(_ urlString: String) -> Bool {
        return true
    }
}
