import SwiftUI
import shared
import AVKit

struct ContentView: View {
    @State private var largestButtonWidth: CGFloat = 0
    private let networking = Networking() // Shared Networking instance
    @State var selectedProvider: Networking.Providers? = nil
    @State var player = AVPlayer(url: Bundle.main.url(forResource: "SpaceAnimation",
                                                      withExtension: "mp4")!)

    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea() // Extend to all edges, ignoring safe areas
                .disabled(true)
            

            VStack {
                Spacer()
                Text("OnlyBoost")
                    .foregroundStyle(.white)
                    .font(Font.custom("FugazOne-Regular", size: 48))
                GeometryReader { reader in
                    CarouselView()
                        .frame(width: reader.size.width)
                        .border(.red, width: 1)
                }
                Spacer()
                createSignInButton(imageResource: .apple, provider: .apple, widthToMatch: largestButtonWidth)
                createSignInButton(imageResource: .google, provider: .google, widthToMatch: largestButtonWidth)
                createSignInButton(imageResource: .microsoft, provider: .microsoft)
                Spacer()
                    .frame(height: 20)
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
        }
        .onAppear {
            setupPlayer()
        }
    }
    
    func createSignInButton(imageResource: ImageResource,
                            provider: Networking.Providers,
                            widthToMatch: CGFloat? = nil
    ) -> some View {
        let providerName = provider.name.capitalized
        let authUrl = Networking.Paths().authEntryPoint(provider: provider)

        func buttonHStack(imageResource: ImageResource, providerName: String) -> some View {
            return HStack {
                Image(imageResource)
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("Sign In with \(providerName)")
                    .foregroundStyle(.black)
            }
        }
        
        return Button {
            selectedProvider = provider
            print("Auth URL for \(providerName): \(authUrl)") // Log the URL
        } label: {
            if let widthToMatch = widthToMatch, widthToMatch != .zero {
                buttonHStack(imageResource: imageResource, providerName: providerName)
                    .frame(width: largestButtonWidth, alignment: .leading)
            } else {
                buttonHStack(imageResource: imageResource, providerName: providerName)
                    .readSize { newSize in
                        if provider == .microsoft { // Use enum comparison
                            largestButtonWidth = newSize.width
                        }
                    }
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(.white)
    }
    
    func setupPlayer() {
        guard let duration = player.currentItem?.duration else { return }
        
        // Observer for forward playback reaching the end
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: duration)], queue: .main) { [weak player] in
            guard let player = player else { return }
            player.rate = -1.0 // Switch to reverse
            
            // Observer for reverse reaching the start
            player.addBoundaryTimeObserver(forTimes: [NSValue(time: CMTime.zero)], queue: .main) { [weak player] in
                player?.pause()
                player?.seek(to: .zero) // Reset to start
            }
        }
    }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
