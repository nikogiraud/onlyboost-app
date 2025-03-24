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
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }

                Text("Think we missed something?")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Add new tag", text: $newTag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                Button("Find Subreddits") {
                    showingSubredditsSheet = true
                }
                .font(.headline)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .navigationTitle("Image Descriptions")
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
            )
        }
        .overlay {
            GlassView()
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
