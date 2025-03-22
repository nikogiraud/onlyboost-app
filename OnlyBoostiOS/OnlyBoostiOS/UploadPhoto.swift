
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

class AppViewModel: ObservableObject {
    @Published var showSignUpPopup = false
    @Published var showSheetStack = false // Controls the entire sheet stack
}

struct UploadPhoto: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showingOptions = false
    @State private var showingPhotoPicker = false
    @State private var showingFilePicker = false
    @State private var showingSubredditsSheet = false
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Image area with border
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Color.white // Placeholder background when no image is selected
                    }
                }
                .frame(width: geometry.size.width - 20, height: geometry.size.height - 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )

                // Upload button centered in the view
                if selectedImage == nil {
                    Button("Upload Photo") {
                        showingOptions = true
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .confirmationDialog("Select Source", isPresented: $showingOptions) {
                        Button("Photo Library") {
                            showingPhotoPicker = true
                        }
                        Button("Files") {
                            showingFilePicker = true
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }

                // Cancel button in the top-right corner
                if selectedImage != nil {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                selectedImage = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                            }
                            .padding()
                        }
                        Spacer()
                    }
                }

                // "Show Captions" button at the bottom
                if selectedImage != nil {
                    VStack {
                        Spacer() // Pushes the button to the bottom
                        Button("Show Captions") {
                            showingSubredditsSheet = true
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20) // Extra padding from the bottom edge
                    }
                }
                
                // Popup overlay
                if viewModel.showSignUpPopup {
                    // Dimmed background
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                viewModel.showSignUpPopup = false
                            }
                        }
                    // Popup content
                    SignUpPopup()
                        .transition(.scale) // Animation for popup
                }
            }
            .padding(10) // Padding around the entire content
        }
        .sheet(isPresented: $viewModel.showSheetStack, content: {
            DescriptionSheet()
                .presentationDetents([.medium])
        })
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker(image: $selectedImage, isPresented: $showingPhotoPicker)
        }
        .sheet(isPresented: $showingFilePicker) {
            FilePicker(image: $selectedImage, isPresented: $showingFilePicker)
        }
        .onChange(of: selectedImage) { newImage in
            if newImage != nil {
                viewModel.showSheetStack = true
            }
        }
        .environmentObject(viewModel)
    }
}



struct DescriptionSheet: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State private var tags: [String] = ["white", "brunette", "bikini", "beach", "thin"]
    @State private var newTag: String = ""
    @State private var showingSubredditsSheet = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }

                Text("Think we missed something?")
                    .font(.headline)
                    .padding(.top)

                HStack {
                    TextField("Add new tag", text: $newTag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        if !newTag.isEmpty {
                            tags.append(newTag)
                            newTag = ""
                        }
                    }
                }
                .padding()

                Button("Find Subreddits") {
                    showingSubredditsSheet = true
                }
                .font(.headline)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .navigationTitle("Image Descriptions")
        }
        .sheet(isPresented: $showingSubredditsSheet) {
            SubredditsSheet(isPresented: $showingSubredditsSheet)
                .presentationDetents([.medium])
        }
    }
}

struct SubredditsSheet: View {
    @Binding var isPresented: Bool
    @State private var subreddits: [String] = ["/r/bikinis", "/r/ebony"]
    @State private var newSubreddit: String = ""
    @State private var showingSchedulePostsSheet = false

    var body: some View {
        NavigationView {
            VStack {
                // Subreddit list in a scrollable grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(subreddits, id: \.self) { subreddit in
                            Text(subreddit)
                                .padding(5)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }

                // Prompt for adding new subreddits
                Text("Think we missed something?")
                    .font(.headline)
                    .padding(.top)

                // Input field and Add button
                HStack {
                    TextField("Add new subreddit", text: $newSubreddit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        if !newSubreddit.isEmpty {
                            subreddits.append(newSubreddit)
                            newSubreddit = ""
                        }
                    }
                }
                .padding()

                // Button to proceed to scheduling
                Button("Continue") {
                    showingSchedulePostsSheet = true
                }
                .font(.headline)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .navigationTitle("Subreddits")
        }
        // Presents the SchedulePostsSheet as a half-sheet
        .sheet(isPresented: $showingSchedulePostsSheet) {
            SchedulePostsSheet(isPresented: $showingSchedulePostsSheet)
                .presentationDetents([.medium])
        }
    }
}

struct SchedulePostsSheet: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Binding var isPresented: Bool
    
    // Non-optional @State variables with default values
    @State private var selectedInitialSpacing: String = "1H"
    @State private var selectedRepostScheduling: String = "3W"
    
    // Options for the segmented controls
    let initialSpacings = ["1H", "6H", "12H", "24H"]
    let repostSchedules = ["3W", "6W", "9W", "12W"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Initial Post Spacing Picker
                Text("Initial Post Spacing")
                    .font(.headline)
                Picker("Initial Post Spacing", selection: $selectedInitialSpacing) {
                    ForEach(initialSpacings, id: \.self) { spacing in
                        Text(spacing)
                    }
                }
                .pickerStyle(.segmented) // Segmented control style
                
                // Repost Scheduling Picker
                Text("Repost Scheduling")
                    .font(.headline)
                Picker("Repost Scheduling", selection: $selectedRepostScheduling) {
                    ForEach(repostSchedules, id: \.self) { schedule in
                        Text(schedule)
                    }
                }
                .pickerStyle(.segmented) // Segmented control style
                
                Spacer()
                
                // Post button
                Button("Post") {
                    print("Selected: \(selectedInitialSpacing), \(selectedRepostScheduling)")
                    viewModel.showSheetStack = false // Dismiss all sheets
                    withAnimation {
                        viewModel.showSignUpPopup = true // Show the popup
                        isPresented = false // Dismiss the sheet
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

            }
            .padding()
            .navigationTitle("Schedule Posts")
        }
    }
}

// Assuming these are your existing PhotoPicker and FilePicker implementations
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false
            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

struct FilePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: FilePicker

        init(_ parent: FilePicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.isPresented = false
            if let url = urls.first, let image = UIImage(contentsOfFile: url.path) {
                DispatchQueue.main.async {
                    self.parent.image = image
                }
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
        }
    }
}

#Preview {
    UploadPhoto()
}
