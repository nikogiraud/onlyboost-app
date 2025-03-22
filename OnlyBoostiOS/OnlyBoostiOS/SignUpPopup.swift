//
//  SignUpPopup.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/22/25.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI

struct SignUpPopup: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.title)
                .fontWeight(.bold)

            Button(action: { print("Google sign-in tapped") }) {
                HStack {
                    Image(systemName: "g.circle")
                    Text("Sign in with Google")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Button(action: { print("Microsoft sign-in tapped") }) {
                HStack {
                    Image(systemName: "m.circle")
                    Text("Sign in with Microsoft")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Button(action: { print("Apple sign-in tapped") }) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Sign in with Apple")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 300) // Limit the width for better appearance
    }
}

#Preview {
    return SignUpPopup()
}
