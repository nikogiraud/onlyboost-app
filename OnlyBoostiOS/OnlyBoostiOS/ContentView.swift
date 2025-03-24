import SwiftUI
import AVKit

struct ContentView: View {
    @State var player = AVPlayer(url: Bundle.main.url(forResource: "SpaceAnimation",
                                                      withExtension: "mp4")!)
    @State var isShowingGuestFlow = false
    var body: some View {
        NavigationStack {
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
                    
                    Button(action: {
                        print("Get Started ->") // Your action here
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                        
                    Spacer()
                        .frame(height: 24)
                    
                    Button {
                        print("Already Registered?")
                    } label: {
                        Text("Already Registered? Sign In")
                    }
                    Spacer()
                        .frame(height: 24)
                }
                .navigationDestination(isPresented: $isShowingGuestFlow, destination: {
                    UploadPhoto()
                })
            }
            .onAppear {
                setupPlayer()
            }
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
