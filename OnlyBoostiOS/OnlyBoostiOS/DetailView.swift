import SwiftUI

struct DetailView: View {
    let imageUrl: String
    let schedules: [SubredditSchedule]

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 300)
                    case .success(let image):
                        image.resizable().scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(maxWidth: .infinity)
                    case .failure:
                        Image(systemName: "photo.fill").resizable().scaledToFit()
                            .frame(maxWidth: .infinity, minHeight: 300).foregroundStyle(.gray)
                    @unknown default: EmptyView()
                    }
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                if !schedules.isEmpty {
                    Text("Scheduled Posts")
                        .font(.title2).fontWeight(.semibold).padding(.horizontal)
                    VStack(spacing: 0) {
                        ForEach(schedules) { schedule in
                            SubredditScheduleRow(schedule: schedule, dateFormatter: dateFormatter)
                            Divider().padding(.leading, 60)
                        }
                    }
                } else {
                    Text("No posts scheduled for this image yet.")
                        .font(.caption).foregroundStyle(.secondary).padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Image Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static let previewSchedules: [SubredditSchedule] = [
        SubredditSchedule(subredditName: "r/DetailPreview", iconUrl: nil, scheduledDates: [
            ScheduledDate(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
            ScheduledDate(date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
        ])
    ]

    static var previews: some View {
        NavigationView {
            DetailView(
                imageUrl: "https://i.imgur.com/3LWLaSL.png",
                schedules: previewSchedules
            )
        }

        NavigationView {
            DetailView(
                imageUrl: "https://i.imgur.com/6jTB0Cz.jpeg",
                schedules: []
            )
        }
        .preferredColorScheme(.dark)
    }
}
