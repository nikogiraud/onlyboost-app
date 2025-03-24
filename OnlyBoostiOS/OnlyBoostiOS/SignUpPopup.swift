//
//  SignUpPopup.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/22/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct SignUpPopup: View {
    private let networking = Networking() // Shared Networking instance
    @State var selectedProvider: Networking.Providers? = nil
    @State private var largestButtonWidth: CGFloat = 0
    let imageSize: CGFloat = 22.5
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            createSignInButton(imageResource: .apple, provider: .apple, widthToMatch: largestButtonWidth)
            createSignInButton(imageResource: .google, provider: .google, widthToMatch: largestButtonWidth)
            createSignInButton(imageResource: .microsoft, provider: .microsoft)
        }
        .padding(20)
        .background(Color(.mainBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
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
}

#Preview {
    return SignUpPopup()
}
