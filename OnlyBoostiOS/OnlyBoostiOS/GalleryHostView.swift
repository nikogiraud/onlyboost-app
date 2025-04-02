import SwiftUI

struct GalleryHostView: View {
    let imageUrls: [String]
    let schedulesLookup: (String) -> [SubredditSchedule]

    @State private var tappedImageUrl: String? = nil
    @State private var showDetailView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ImageGalleryCollectionView(imageIdentifiers: imageUrls) { index in
                    guard index >= 0 && index < imageUrls.count else { return }
                    let selectedUrl = imageUrls[index]
                    self.tappedImageUrl = selectedUrl
                    self.showDetailView = true
                }
            }
            .navigationTitle("Select Image")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showDetailView) {
                if let url = tappedImageUrl {
                    DetailView(imageUrl: url, schedules: schedulesLookup(url))
                }
            }
        }
    }
}

struct GalleryHostView_Previews: PreviewProvider {
    static let sampleImageUrls = [
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
        "https://i.imgur.com/3LWLaSL.png",
        "https://i.imgur.com/6jTB0Cz.jpeg",
    ]

    static let sampleScheduleData: [String: [SubredditSchedule]] = [
        "https://i.imgur.com/3LWLaSL.png": [
            SubredditSchedule(subredditName: "r/Landscape", iconUrl: nil, scheduledDates: [ScheduledDate(date: Date()), ScheduledDate(date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!)])
        ],
        "https://i.imgur.com/6jTB0Cz.jpeg": [
            SubredditSchedule(subredditName: "r/Portrait", iconUrl: nil, scheduledDates: [ScheduledDate(date: Calendar.current.date(byAdding: .hour, value: 8, to: Date())!)])
        ]
    ]

    static func previewSchedulesLookup(imageUrl: String) -> [SubredditSchedule] {
        return sampleScheduleData[imageUrl] ?? []
    }

    static var previews: some View {
        GalleryHostView(
            imageUrls: sampleImageUrls,
            schedulesLookup: previewSchedulesLookup
        )
        
        GalleryHostView(
            imageUrls: [sampleImageUrls[1], sampleImageUrls[0]],
            schedulesLookup: previewSchedulesLookup
        )
        .preferredColorScheme(.dark)
    }
}
