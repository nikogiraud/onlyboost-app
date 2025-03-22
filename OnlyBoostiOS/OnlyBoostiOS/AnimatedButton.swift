//
//  AnimatedButton.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/21/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

struct AnimatedButton: View {
//    @State private var isTapped = false
    
    var body: some View {
        Button(action: {
//            // Trigger the pressed effect
//            withAnimation(.easeOut(duration: 0.1)) {
//                isTapped = true
//            }
//            // Reset after a short delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                withAnimation(.easeIn(duration: 0.1)) {
//                    isTapped = false
//                }
//            }
            print("Button tapped!") // Your action here
        }) {
            Text("Tap Me")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

struct AnimatedButton_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedButton()
    }
}
