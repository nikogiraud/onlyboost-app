import SwiftUI
import shared

struct ContentView: View {
    @State private var largestButtonWidth: CGFloat = 0
    private let networking = Networking() // Shared Networking instance
    @State var selectedProvider: Networking.Providers? = nil
    
    var body: some View {
        VStack {
            createSignInButton(imageResource: .apple, provider: .apple, widthToMatch: largestButtonWidth)
            createSignInButton(imageResource: .google, provider: .google, widthToMatch: largestButtonWidth)
            createSignInButton(imageResource: .microsoft, provider: .microsoft)
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
        .buttonStyle(.bordered)
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
