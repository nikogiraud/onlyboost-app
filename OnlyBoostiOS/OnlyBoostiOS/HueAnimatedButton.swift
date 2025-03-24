//
//  HueAnimatedButton.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/24/25.
//  Copyright © 2025 orgName. All rights reserved.
//


import SwiftUI

struct HueAnimatedButton: View {
    @State private var hueRotation = Angle.degrees(0)
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 14/255, green: 165/255, blue: 233/255),
                Color(red: 139/255, green: 92/255, blue: 246/255)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 200, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .hueRotation(hueRotation)
        .overlay(
            Text("Click Me")
                .foregroundColor(.white)
        )
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
                hueRotation = Angle.degrees(360)
            }
        }
    }
}

#Preview {
    HueAnimatedButton()
}
