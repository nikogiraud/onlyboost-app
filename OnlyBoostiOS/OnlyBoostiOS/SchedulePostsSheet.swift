//
//  SchedulePostsSheet.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/24/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

struct SchedulePostsSheet: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Binding var isPresented: Bool
    
    // Non-optional @State variables with default values
    @State private var selectedInitialSpacing: String = "1H"
    @State private var selectedRepostScheduling: String = "3W"
    
    // Options for the segmented controls
    let initialSpacings = ["1H", "6H", "12H", "24H"]
    let repostSchedules = ["3W", "6W", "9W", "12W"]
    
    @State var initialSpacingIndex = 0
    @State var repostSchedulesIndex = 0
    
    let segmentedControlHeight: CGFloat = 35
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Initial Post Spacing Picker
                Text("Initial Post Spacing")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                SegmentedControl(segments: initialSpacings,
                                 selectedIndex: $initialSpacingIndex)
                .frame(height: segmentedControlHeight)
                
                
                Spacer()
                    .frame(height: 20)
                
                // Repost Scheduling Picker
                Text("Repost Scheduling")
                    .font(.headline)
                    .foregroundStyle(.white)
                SegmentedControl(segments: repostSchedules,
                                 selectedIndex: $repostSchedulesIndex)
                .frame(height: segmentedControlHeight)
                
                Spacer()
                
                // Post button
                Button("Post") {
                    print("Selected: \(selectedInitialSpacing), \(selectedRepostScheduling)")
                    viewModel.showSheetStack = false // Dismiss all sheets
                    withAnimation {
                        viewModel.showSignUpPopup = true // Show the popup
                        isPresented = false // Dismiss the sheet
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    LoopingGradientView(isAnimating: true)
                }
                .foregroundColor(.white)
                .cornerRadius(10)

            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Subreddits")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .background(
                Color(.mainBackground)
                    .overlay {
                        GlassView()
                    }
                    .ignoresSafeArea()
            )
        }

    }
}

#Preview {
    @Previewable @State var isPresented = true
    SchedulePostsSheet(isPresented: $isPresented)
}
