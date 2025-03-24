import SwiftUI

struct LoopingGradientView: View {
    // Define initial colors
    private let color1 = Color(red: 14/255, green: 165/255, blue: 233/255)  // Sky blue
    private let color2 = Color(red: 139/255, green: 92/255, blue: 246/255)  // Purple
    
    // State to animate the hue rotation angle
    @State private var hueAngle: Angle = .degrees(0)
    var isAnimating: Bool
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: [color1, color2]),
                startPoint: .leading,
                endPoint: .trailing
            )
            // Apply hue rotation with animation
            .hueRotation(isAnimating ? hueAngle : .zero)
            .animation(
                Animation.linear(duration: 2) // 4 seconds for one full cycle
                    .repeatForever(autoreverses: true), // Loop forever in one direction
                value: hueAngle
            )
            .onAppear {
                // Start the animation by rotating to 60 degrees
                hueAngle = .degrees(60)
            }
        }
    }
}

#Preview {
    Button(action: {
        print("Pressed")
    }, label: {
        Text("Press me!")
    })
    .padding()
    .background(content: {
        LoopingGradientView(isAnimating: true)
    })
}
