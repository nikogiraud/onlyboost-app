//
//  AnimatedGradientButton.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/24/25.
//  Copyright © 2025 orgName. All rights reserved.
//


import SwiftUI

struct AnimatedGradientButton: View {
    @State private var animate = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 14/255, green: 165/255, blue: 233/255),
                Color(red: 139/255, green: 92/255, blue: 246/255),
                Color(red: 14/255, green: 165/255, blue: 233/255) // Repeated for smooth loop
            ]),
            startPoint: animate ? .trailing : .leading,
            endPoint: animate ? .leading : .trailing
        )
        .frame(width: 200, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            Text("Click Me")
                .foregroundColor(.white)
        )
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                animate.toggle()
            }
        }
    }
}

#Preview {
    AnimatedGradientButton()
}
