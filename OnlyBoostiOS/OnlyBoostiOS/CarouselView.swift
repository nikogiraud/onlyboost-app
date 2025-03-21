import SwiftUI

struct CarouselView: View {
    @State private var activeIndex = 0
    @State private var showSubreddits = false
    @State private var subredditOpacity: Double = 0.0 // Start at 0 for fade-in
    @State private var isDragging = false
    
    let images = [
        "https://i.imgur.com/XyvrE7X.png",
        "https://placehold.co/300x400/blue/yellow?text=Image2",
        "https://placehold.co/300x400/green/black?text=Image3",
        "https://placehold.co/300x400/purple/white?text=Image4",
        "https://placehold.co/300x400/orange/black?text=Image5"
    ]
    
    let subredditLists: [[String]] = [
        ["r/red", "r/warm", "r/bold"],
        ["r/blue", "r/cool", "r/calm"],
        ["r/green", "r/nature", "r/fresh"],
        ["r/purple", "r/royal", "r/mysterious"],
        ["r/orange", "r/vibrant", "r/energetic"]
    ]
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            ImageCarousel(activeIndex: $activeIndex, images: images)
                .frame(height: 400)
                .clipped()
            
            if showSubreddits {
                SubredditList(subreddits: subredditLists[activeIndex])
                    .opacity(subredditOpacity) // Apply opacity here
            }
        }
        .onChange(of: showSubreddits) { newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                subredditOpacity = newValue ? 1.0 : 0.0 // Fade in or out
            }
        }
        .onReceive(timer) { _ in
            if !isDragging { autoSlide() }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSubreddits = true // Trigger initial fade-in
                }
            }
        }
    }

    private func autoSlide() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showSubreddits = false // Fade out
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                activeIndex = (activeIndex + 1) % images.count // Slide image
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSubreddits = true // Fade in new list
                }
            }
        }
    }
}

// Supporting views remain unchanged
struct ImageCarousel: View {
    @Binding var activeIndex: Int
    let images: [String]

    var body: some View {
        TabView(selection: $activeIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                AsyncImage(url: URL(string: images[index])) { image in
                    imageView(image, isActive: index == activeIndex)
                } placeholder: {
                    placeholderView
                }
                .frame(width: 200, height: 200)
                .tag(index)
                .padding(.horizontal, 10)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .animation(.easeInOut(duration: 0.8), value: activeIndex)
    }

    @ViewBuilder
    private func imageView(_ image: Image, isActive: Bool) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(isActive ? 1.0 : 0.7)
            .transition(.slide)
    }

    private var placeholderView: some View {
        Color.gray
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SubredditList: View {
    let subreddits: [String]

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            ForEach(subreddits, id: \.self) { subreddit in
                Text(subreddit)
                    .font(.custom("FugazOne-Regular", size: 16))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.purple.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .border(.red, width: 1)
    }
}

extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255
        )
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
