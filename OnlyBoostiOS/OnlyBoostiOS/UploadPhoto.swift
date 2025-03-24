
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import shared

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
    private let networking = Networking() // Shared Networking instance
    @State var selectedProvider: Networking.Providers? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Image area with border
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: geometry.size.width - 20, height: geometry.size.height - 20)
                .overlay(
                    GlassView()
                )

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

                // Upload button centered in the view
                if selectedImage == nil {
                    VStack {
                        Spacer()
                        Button("Upload Photo") {
                            showingOptions = true
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(content: {
                            LoopingGradientView(isAnimating: true)
                        })
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
                } else {
                    VStack {
                        Spacer()
                        Button("Show Captions") {
                            showingSubredditsSheet = true
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
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
            .background(Color(.mainBackground))
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
        .onChange(of: selectedImage) { _, newImage in
            if newImage != nil {
                viewModel.showSheetStack = true
            }
        }
        .sheet(item: $selectedProvider) {
            selectedProvider = nil
        } content: { selectedProvider in
            AuthorizationWebView(urlPath: Networking.Paths().authEntryPoint(provider: selectedProvider)) { sessionToken in
                print("ToDO: save token in keychain:", sessionToken)
            } loginFailed: { failed in
                print("Login failed!: \(failed)")
            }
        }
        .environmentObject(viewModel)
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

extension Networking.Providers: @retroactive Identifiable {
    public var id: String {
        switch self {
        case .google: return "google"
        case .microsoft: return "microsoft"
        case .apple: return "apple"
        default: return "unknown" // Handle exhaustiveness
        }
    }
}
