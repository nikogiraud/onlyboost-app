//
//  ImageLoader.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/20/25.
//  Copyright © 2025 orgName. All rights reserved.
//


import SwiftUI

class ImageLoader: ObservableObject {
    @Published var images: [UIImage?] = []
    private var urls: [String] = []
    
    init(urls: [String]) {
        self.urls = urls
        self.images = Array(repeating: nil, count: urls.count)
        loadImages()
    }
    
    private func loadImages() {
        for (index, urlString) in urls.enumerated() {
            guard let url = URL(string: urlString) else { continue }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.images[index] = image
                    }
                }
            }.resume()
        }
    }
}