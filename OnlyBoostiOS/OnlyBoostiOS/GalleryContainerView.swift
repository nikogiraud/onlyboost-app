import SwiftUI

struct GalleryContainerView: View {
    @State private var imageUrls = [
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
    ]

    @State private var tappedImageIndex: Int? = nil
    @State private var showDetailView = false

    var body: some View {
        NavigationView {
            VStack {
                ImageGalleryCollectionView(imageIdentifiers: imageUrls) { index in
                    print("Tapped image at index: \(index)")
                    self.tappedImageIndex = index
                    self.showDetailView = true
                }

                NavigationLink(
                    destination: DetailView(imageUrl: imageUrls[tappedImageIndex ?? 0]),
                    isActive: $showDetailView
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Gallery")
        }
    }
}

struct DetailView: View {
    let imageUrl: String

    var body: some View {
        VStack {
            Text("Detail View")
            Text("Showing image from URL:")
            Text(imageUrl).font(.caption)
            Spacer()
        }
        .navigationTitle("Image Detail")
    }
}

struct GalleryContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryContainerView()
    }
}
