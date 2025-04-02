import SwiftUI
import UIKit

struct ImageGalleryCollectionView: UIViewRepresentable {
    var imageIdentifiers: [String]
    var onTap: (Int) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 5
        let totalSpacing = (3 - 1) * spacing
        let availableWidth = UIScreen.main.bounds.width - (2 * spacing) - totalSpacing
        let itemWidth = availableWidth / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.reuseIdentifier)

        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.parent = self
        uiView.reloadData()
    }

    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        var parent: ImageGalleryCollectionView

        init(_ parent: ImageGalleryCollectionView) {
            self.parent = parent
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.imageIdentifiers.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGalleryCell.reuseIdentifier, for: indexPath) as? ImageGalleryCell else {
                return UICollectionViewCell()
            }

            let identifier = parent.imageIdentifiers[indexPath.item]
            cell.configure(with: identifier)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            parent.onTap(indexPath.item)
        }
    }
}
