//
//  SubredditsSheet.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/24/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

struct SubredditsSheet: View {
    @Binding var isPresented: Bool
    @State private var subreddits: [String] = ["/r/bikinis", "/r/ebony"]
    @State private var newSubreddit: String = ""
    @State private var showingSchedulePostsSheet = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Subreddit list in a scrollable grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(subreddits, id: \.self) { subreddit in
                            Text(subreddit)
                                .padding()
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .cornerRadius(5)
                        }
                    }
                }

                // Prompt for adding new subreddits
                Text("Did we miss any?")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding(.top)

                TextField("",
                          text: $newSubreddit,
                          prompt: Text("Add new subreddit").foregroundStyle(.gray))
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Spacer()
                    .frame(height: 20)
                
                // Button to proceed to scheduling
                Button("Continue") {
                    showingSchedulePostsSheet = true
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    LoopingGradientView(isAnimating: true)
                }
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
                    .frame(height: 20)
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
        // Presents the SchedulePostsSheet as a half-sheet
        .sheet(isPresented: $showingSchedulePostsSheet) {
            SchedulePostsSheet(isPresented: $showingSchedulePostsSheet)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    SubredditsSheet(isPresented: $isPresented)
}
