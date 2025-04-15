import SwiftUI

struct GalleryContainerView: View {
    @State var imageUrls: [String]
    @State private var tappedImageIndex: Int? = nil
    @State private var showDetailView = false
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "mainBackground") ?? .black // Optional

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ImageGalleryCollectionView(imageIdentifiers: imageUrls) { index in
                    print("Tapped image at index: \(index)")
                    self.tappedImageIndex = index
                    self.showDetailView = true
                }
            }
            .navigationBarTitle("Title", displayMode: .large)
            .navigationBarTitleDisplayMode(.large)
            .background {
                Color(.mainBackground)
                    .ignoresSafeArea()
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
    return GalleryContainerView(imageUrls: [
        "https://i.imgur.com/DJNhMBU.png",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/DJNhMBU.png",
        "https://i.imgur.com/3LWLaSL.png"
    ])
}
