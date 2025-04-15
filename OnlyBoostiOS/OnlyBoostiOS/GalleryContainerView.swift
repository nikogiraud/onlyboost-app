import SwiftUI

struct GalleryContainerView: View {
    @State var imageUrls: [String]
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
            }
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
    
#Preview {
    return GalleryContainerView(imageUrls: ["abc.com", "xyz.com", "pqr.com"])
}
