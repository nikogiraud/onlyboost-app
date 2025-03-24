//
//  GradientView.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/24/25.
//  Copyright © 2025 orgName. All rights reserved.
//


import SwiftUI

struct GlassView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.white.opacity(0.15), lineWidth: 3)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.02)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

#Preview {
    VStack {
        GlassView()
            .frame(width: 300, height: 200)
            .background(Color(.mainBackground))
        Text("Hello, World!")
            .frame(width: 300, height: 200)
            .background(Color(.mainBackground))
    }
}
