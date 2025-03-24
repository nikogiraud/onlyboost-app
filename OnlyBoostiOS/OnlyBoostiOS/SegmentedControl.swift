import SwiftUI

struct SegmentedControl: View {
    // Properties
    let segments: [String]
    @Binding var selectedIndex: Int
    let selectedBackgroundColor: Color
    let selectedTextColor: Color
    let unselectedTextColor: Color
    
    init(
        segments: [String],
        selectedIndex: Binding<Int>,
        selectedBackgroundColor: Color = .blue,
        selectedTextColor: Color = .white,
        unselectedTextColor: Color = .gray
    ) {
        self.segments = segments
        self._selectedIndex = selectedIndex
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.unselectedTextColor = unselectedTextColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                Capsule()
                    .fill(selectedBackgroundColor)
                    .frame(width: geometry.size.width / CGFloat(segments.count))
                    .offset(x: CGFloat(selectedIndex) * (geometry.size.width / CGFloat(segments.count)), y: 0)
                    .animation(.default, value: selectedIndex) // Ensures animation in app
                
                HStack(spacing: 0) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(segments[index])
                            .foregroundColor(selectedIndex == index ? selectedTextColor : unselectedTextColor)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedIndex = 1
        var body: some View {
            SegmentedControl(
                segments: ["First", "Second", "Third"],
                selectedIndex: $selectedIndex,
                selectedBackgroundColor: .green,
                selectedTextColor: .white,
                unselectedTextColor: .gray
            )
            .frame(width: 300, height: 50)
        }
    }
    return PreviewWrapper()
}
