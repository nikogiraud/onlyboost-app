//
//  DescriptionSheet.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/24/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

struct DescriptionSheet: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State private var tags: [String] = ["white", "brunette", "bikini", "beach", "thin"]
    @State private var newTag: String = ""
    @State private var showingSubredditsSheet = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .padding(5)
                                .foregroundStyle(Color.white)
                                .background(Color.blue)
                                .cornerRadius(5)
                        }
                    }
                }
                
                Text("Did we miss any?")
                    .font(.headline)
                    .foregroundStyle(.white)
                TextField("",
                          text: $newTag,
                          prompt: Text("Add new subreddit").foregroundStyle(.gray))
                .padding(10)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                
                Spacer()
                    .frame(height: 20)
                
                Button("Find Subreddits") {
                    showingSubredditsSheet = true
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
                    Text("Image Captions")
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
        .sheet(isPresented: $showingSubredditsSheet) {
            SubredditsSheet(isPresented: $showingSubredditsSheet)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    DescriptionSheet()
}
